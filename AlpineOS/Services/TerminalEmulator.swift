//
//  TerminalEmulator.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import Foundation
import Combine
import SwiftUI

class TerminalEmulator: ObservableObject {
    @Published var outputLines: [String] = []
    @Published var currentPrompt: String = "alpine:~$ "
    
    private let commandExecutor = CommandExecutor.shared
    private var cancellables = Set<AnyCancellable>()
    private var currentProcess: Process?
    
    init() {
        setupObservers()
        displayWelcomeMessage()
    }
    
    private func setupObservers() {
        // Observe command output
        commandExecutor.$lastOutput
            .sink { [weak self] output in
                if let output = output, !output.isEmpty {
                    self?.addOutput(output)
                }
            }
            .store(in: &cancellables)
    }
    
    private func displayWelcomeMessage() {
        let welcome = """
        
        Welcome to AlpineOS Terminal v1.0
        Running Alpine Linux on iOS
        
        Type 'help' for available commands
        Type 'clear' to clear the screen
        
        """
        addOutput(welcome)
    }
    
    func executeCommand(_ command: String) {
        let trimmedCommand = command.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedCommand.isEmpty else { return }
        
        // Handle built-in commands
        switch trimmedCommand {
        case "clear":
            clearScreen()
            return
        case "help":
            showHelp()
            return
        case "exit", "quit":
            addOutput("Use the iOS app switcher to close the app")
            return
        default:
            break
        }
        
        // Execute command through CommandExecutor
        commandExecutor.execute(command: trimmedCommand) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let output):
                    if !output.isEmpty {
                        self?.addOutput(output)
                    }
                case .failure(let error):
                    self?.addOutput("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func addOutput(_ text: String) {
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false)
        outputLines.append(contentsOf: lines.map(String.init))
    }
    
    func clearScreen() {
        outputLines.removeAll()
        displayWelcomeMessage()
    }
    
    func interruptCurrentProcess() {
        currentProcess?.interrupt()
        addOutput("^C")
    }
    
    func getColorForLine(_ line: String) -> Color {
        if line.hasPrefix("Error:") || line.hasPrefix("error:") {
            return .red
        } else if line.hasPrefix("Warning:") || line.hasPrefix("warning:") {
            return .yellow
        } else if line.contains("alpine:") && line.contains("$") {
            return .green
        } else {
            return .white
        }
    }
    
    private func showHelp() {
        let help = """
        
        Available Commands:
        
        File Operations:
          ls [path]           - List directory contents
          cd [path]           - Change directory
          pwd                 - Print working directory
          mkdir <name>        - Create directory
          touch <name>        - Create file
          rm <file>           - Remove file
          cat <file>          - Display file contents
          echo <text>         - Print text
          cp <src> <dst>      - Copy file
          mv <src> <dst>      - Move/rename file
        
        System:
          clear               - Clear screen
          help                - Show this help
          uname               - Show system information
          date                - Show current date/time
          whoami              - Print current user
        
        Package Management:
          apk update          - Update package index
          apk search <pkg>    - Search for packages
          apk add <pkg>       - Install package
          apk del <pkg>       - Remove package
          apk list            - List installed packages
        
        """
        addOutput(help)
    }
}
