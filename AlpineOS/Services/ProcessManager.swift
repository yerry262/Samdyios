//
//  ProcessManager.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import Foundation

struct ProcessInfo {
    let pid: Int
    let name: String
    let state: String
    let startTime: Date
}

class ProcessManager: ObservableObject {
    static let shared = ProcessManager()
    
    @Published private(set) var runningProcesses: [ProcessInfo] = []
    
    private var processes: [Int: Process] = [:]
    private var nextPID = 1000
    
    private init() {
        // Initialize with the shell process
        let shellProcess = ProcessInfo(
            pid: 1,
            name: "ash",
            state: "running",
            startTime: Date()
        )
        runningProcesses.append(shellProcess)
    }
    
    func startProcess(name: String, command: String, completion: @escaping (Int, String) -> Void) -> Int {
        let pid = nextPID
        nextPID += 1
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", command]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            processes[pid] = process
            
            let processInfo = ProcessInfo(
                pid: pid,
                name: name,
                state: "running",
                startTime: Date()
            )
            
            DispatchQueue.main.async {
                self.runningProcesses.append(processInfo)
            }
            
            // Read output asynchronously
            DispatchQueue.global(qos: .userInitiated).async {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""
                
                DispatchQueue.main.async {
                    self.removeProcess(pid: pid)
                    completion(pid, output)
                }
            }
            
            return pid
        } catch {
            return -1
        }
    }
    
    func killProcess(pid: Int) -> Bool {
        guard let process = processes[pid] else {
            return false
        }
        
        process.terminate()
        removeProcess(pid: pid)
        return true
    }
    
    func getProcessInfo(pid: Int) -> ProcessInfo? {
        return runningProcesses.first { $0.pid == pid }
    }
    
    func listProcesses() -> [ProcessInfo] {
        return runningProcesses
    }
    
    private func removeProcess(pid: Int) {
        processes.removeValue(forKey: pid)
        runningProcesses.removeAll { $0.pid == pid }
    }
    
    func sendSignal(_ signal: Signal, to pid: Int) -> Bool {
        guard let process = processes[pid] else {
            return false
        }
        
        switch signal {
        case .interrupt:
            process.interrupt()
        case .terminate:
            process.terminate()
        case .kill:
            process.terminate() // iOS doesn't expose kill signal directly
        }
        
        return true
    }
}

enum Signal {
    case interrupt  // SIGINT
    case terminate  // SIGTERM
    case kill       // SIGKILL
}
