//
//  CommandExecutor.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import Foundation

enum CommandError: Error {
    case commandNotFound
    case invalidArguments
    case executionFailed(String)
    case permissionDenied
}

class CommandExecutor: ObservableObject {
    static let shared = CommandExecutor()
    
    @Published var lastOutput: String?
    private var currentDirectory: String = "~"
    private let fileSystemManager = FileSystemManager.shared
    
    private init() {}
    
    func execute(command: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parts = command.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
        
        guard let cmd = parts.first else {
            completion(.failure(CommandError.commandNotFound))
            return
        }
        
        let args = Array(parts.dropFirst())
        
        // Route to appropriate command handler
        switch cmd {
        case "ls":
            handleLs(args: args, completion: completion)
        case "cd":
            handleCd(args: args, completion: completion)
        case "pwd":
            handlePwd(completion: completion)
        case "mkdir":
            handleMkdir(args: args, completion: completion)
        case "touch":
            handleTouch(args: args, completion: completion)
        case "rm":
            handleRm(args: args, completion: completion)
        case "cat":
            handleCat(args: args, completion: completion)
        case "echo":
            handleEcho(args: args, completion: completion)
        case "cp":
            handleCp(args: args, completion: completion)
        case "mv":
            handleMv(args: args, completion: completion)
        case "uname":
            handleUname(args: args, completion: completion)
        case "date":
            handleDate(completion: completion)
        case "whoami":
            handleWhoami(completion: completion)
        case "apk":
            handleApk(args: args, completion: completion)
        default:
            completion(.failure(CommandError.commandNotFound))
        }
    }
    
    // MARK: - Command Handlers
    
    private func handleLs(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        let path = args.first ?? currentDirectory
        let files = fileSystemManager.listFiles(at: path)
        
        if files.isEmpty {
            completion(.success(""))
        } else {
            let output = files.map { item in
                if item.isDirectory {
                    return "\(item.name)/"
                } else {
                    return item.name
                }
            }.joined(separator: "\n")
            completion(.success(output))
        }
    }
    
    private func handleCd(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let path = args.first else {
            currentDirectory = "~"
            completion(.success(""))
            return
        }
        
        if fileSystemManager.directoryExists(at: path) {
            currentDirectory = path
            completion(.success(""))
        } else {
            completion(.failure(CommandError.executionFailed("cd: no such directory: \(path)")))
        }
    }
    
    private func handlePwd(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success(currentDirectory))
    }
    
    private func handleMkdir(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard !args.isEmpty else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        // Check for -p flag
        let hasParentFlag = args.contains("-p")
        let paths = args.filter { $0 != "-p" }
        
        guard !paths.isEmpty else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        for name in paths {
            if hasParentFlag {
                // Create with parent directories
                if !fileSystemManager.createDirectoryWithParents(name: name, at: currentDirectory) {
                    completion(.failure(CommandError.executionFailed("mkdir: cannot create directory '\(name)'")))
                    return
                }
            } else {
                // Create single directory
                if !fileSystemManager.createDirectory(name: name, at: currentDirectory) {
                    completion(.failure(CommandError.executionFailed("mkdir: cannot create directory '\(name)'")))
                    return
                }
            }
        }
        
        completion(.success(""))
    }
    
    private func handleTouch(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let name = args.first else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        if fileSystemManager.createFile(name: name, at: currentDirectory, content: "") {
            completion(.success(""))
        } else {
            completion(.failure(CommandError.executionFailed("touch: cannot create file '\(name)'")))
        }
    }
    
    private func handleRm(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let name = args.first else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        let fullPath = resolvePath(name)
        if fileSystemManager.deleteItem(at: fullPath) {
            completion(.success(""))
        } else {
            completion(.failure(CommandError.executionFailed("rm: cannot remove '\(name)'")))
        }
    }
    
    private func handleCat(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let name = args.first else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        let fullPath = resolvePath(name)
        if let content = fileSystemManager.readFile(at: fullPath) {
            completion(.success(content))
        } else {
            completion(.failure(CommandError.executionFailed("cat: \(name): No such file")))
        }
    }
    
    private func handleEcho(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        let output = args.joined(separator: " ")
        completion(.success(output))
    }
    
    private func handleCp(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard args.count >= 2 else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        let source = resolvePath(args[0])
        let destination = resolvePath(args[1])
        
        if fileSystemManager.copyItem(from: source, to: destination) {
            completion(.success(""))
        } else {
            completion(.failure(CommandError.executionFailed("cp: cannot copy '\(args[0])' to '\(args[1])'")))
        }
    }
    
    private func handleMv(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard args.count >= 2 else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        let source = resolvePath(args[0])
        let destination = resolvePath(args[1])
        
        if fileSystemManager.moveItem(from: source, to: destination) {
            completion(.success(""))
        } else {
            completion(.failure(CommandError.executionFailed("mv: cannot move '\(args[0])' to '\(args[1])'")))
        }
    }
    
    private func handleUname(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        if args.contains("-a") {
            completion(.success("AlpineOS 3.19.0 iOS arm64"))
        } else {
            completion(.success("AlpineOS"))
        }
    }
    
    private func handleDate(completion: @escaping (Result<String, Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .long
        completion(.success(formatter.string(from: Date())))
    }
    
    private func handleWhoami(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("alpine"))
    }
    
    private func handleApk(args: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let subcommand = args.first else {
            completion(.failure(CommandError.invalidArguments))
            return
        }
        
        switch subcommand {
        case "update":
            completion(.success("Updating package index...\nDone."))
        case "list":
            completion(.success("bash\ncoreutils\nbusybox\nalpine-base"))
        case "search":
            if args.count > 1 {
                completion(.success("Searching for '\(args[1])'...\nNo results found (simulated)."))
            } else {
                completion(.failure(CommandError.invalidArguments))
            }
        case "add":
            if args.count > 1 {
                completion(.success("Installing \(args[1])...\nDone (simulated)."))
            } else {
                completion(.failure(CommandError.invalidArguments))
            }
        case "del":
            if args.count > 1 {
                completion(.success("Removing \(args[1])...\nDone (simulated)."))
            } else {
                completion(.failure(CommandError.invalidArguments))
            }
        default:
            completion(.failure(CommandError.commandNotFound))
        }
    }
    
    // MARK: - Helper Methods
    
    private func resolvePath(_ path: String) -> String {
        if path.hasPrefix("/") {
            return path
        } else if path.hasPrefix("~") {
            return path.replacingOccurrences(of: "~", with: fileSystemManager.homeDirectory)
        } else {
            return "\(currentDirectory)/\(path)"
        }
    }
}
