//
//  FileSystemManager.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import Foundation

struct FileItem {
    let name: String
    let path: String
    let isDirectory: Bool
    let size: Int64
    let modificationDate: Date
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: modificationDate)
    }
}

class FileSystemManager: ObservableObject {
    static let shared = FileSystemManager()
    
    private let fileManager = FileManager.default
    let homeDirectory: String
    private let documentsDirectory: URL
    
    @Published private(set) var currentDirectory: String
    
    private init() {
        // Set up the home directory within the app's Documents folder
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        homeDirectory = documentsDirectory.appendingPathComponent("alpine").path
        currentDirectory = homeDirectory
    }
    
    func initializeFileSystem() {
        // Create the Alpine directory structure
        let directories = [
            homeDirectory,
            "\(homeDirectory)/bin",
            "\(homeDirectory)/etc",
            "\(homeDirectory)/home",
            "\(homeDirectory)/tmp",
            "\(homeDirectory)/var",
            "\(homeDirectory)/usr",
            "\(homeDirectory)/usr/local",
            "\(homeDirectory)/usr/share"
        ]
        
        for dir in directories {
            createDirectoryIfNeeded(at: dir)
        }
        
        // Create a welcome file
        let welcomePath = "\(homeDirectory)/README.txt"
        let welcomeContent = """
        Welcome to AlpineOS on iOS!
        
        This is a lightweight Alpine Linux environment running on your iOS device.
        
        Features:
        - Full terminal emulator with VT100/ANSI support
        - File system management
        - Basic Unix commands (ls, cd, mkdir, cat, etc.)
        - Package management with apk
        
        Get started:
        1. Type 'help' in the terminal for available commands
        2. Explore the file system with 'ls' and 'cd'
        3. Create files and directories
        4. Manage packages with 'apk'
        
        Enjoy!
        """
        
        if !fileManager.fileExists(atPath: welcomePath) {
            try? welcomeContent.write(toFile: welcomePath, atomically: true, encoding: .utf8)
        }
    }
    
    // MARK: - Directory Operations
    
    func listFiles(at path: String) -> [FileItem] {
        let resolvedPath = resolvePath(path)
        
        guard let contents = try? fileManager.contentsOfDirectory(atPath: resolvedPath) else {
            return []
        }
        
        return contents.compactMap { name in
            let fullPath = "\(resolvedPath)/\(name)"
            guard let attributes = try? fileManager.attributesOfItem(atPath: fullPath) else {
                return nil
            }
            
            let isDirectory = (attributes[.type] as? FileAttributeType) == .typeDirectory
            let size = attributes[.size] as? Int64 ?? 0
            let modificationDate = attributes[.modificationDate] as? Date ?? Date()
            
            return FileItem(
                name: name,
                path: fullPath,
                isDirectory: isDirectory,
                size: size,
                modificationDate: modificationDate
            )
        }.sorted { item1, item2 in
            if item1.isDirectory != item2.isDirectory {
                return item1.isDirectory
            }
            return item1.name.lowercased() < item2.name.lowercased()
        }
    }
    
    func createDirectory(name: String, at path: String) -> Bool {
        let resolvedPath = resolvePath(path)
        let fullPath = "\(resolvedPath)/\(name)"
        
        return createDirectoryIfNeeded(at: fullPath)
    }
    
    func directoryExists(at path: String) -> Bool {
        let resolvedPath = resolvePath(path)
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: resolvedPath, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
    func parentDirectory(of path: String) -> String {
        let resolvedPath = resolvePath(path)
        let url = URL(fileURLWithPath: resolvedPath)
        let parent = url.deletingLastPathComponent().path
        
        // Don't go above home directory
        if parent.count < homeDirectory.count {
            return homeDirectory
        }
        
        return parent
    }
    
    // MARK: - File Operations
    
    @discardableResult
    func createFile(name: String, at path: String, content: String = "") -> Bool {
        let resolvedPath = resolvePath(path)
        let fullPath = "\(resolvedPath)/\(name)"
        
        return fileManager.createFile(atPath: fullPath, contents: content.data(using: .utf8), attributes: nil)
    }
    
    func readFile(at path: String) -> String? {
        let resolvedPath = resolvePath(path)
        return try? String(contentsOfFile: resolvedPath, encoding: .utf8)
    }
    
    func writeFile(at path: String, content: String) -> Bool {
        let resolvedPath = resolvePath(path)
        do {
            try content.write(toFile: resolvedPath, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteItem(at path: String) -> Bool {
        let resolvedPath = resolvePath(path)
        do {
            try fileManager.removeItem(atPath: resolvedPath)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func copyItem(from source: String, to destination: String) -> Bool {
        let resolvedSource = resolvePath(source)
        let resolvedDestination = resolvePath(destination)
        
        do {
            try fileManager.copyItem(atPath: resolvedSource, toPath: resolvedDestination)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func moveItem(from source: String, to destination: String) -> Bool {
        let resolvedSource = resolvePath(source)
        let resolvedDestination = resolvePath(destination)
        
        do {
            try fileManager.moveItem(atPath: resolvedSource, toPath: resolvedDestination)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Storage Info
    
    func getUsedSpace() -> String {
        let allocatedSize = try? documentsDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage
        
        if let size = allocatedSize {
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            return formatter.string(fromByteCount: Int64(size))
        }
        
        return "Unknown"
    }
    
    func clearCache() {
        let cachePath = "\(homeDirectory)/tmp"
        if let contents = try? fileManager.contentsOfDirectory(atPath: cachePath) {
            for item in contents {
                let fullPath = "\(cachePath)/\(item)"
                try? fileManager.removeItem(atPath: fullPath)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func resolvePath(_ path: String) -> String {
        if path == "~" || path == "" {
            return homeDirectory
        } else if path.hasPrefix("~/") {
            return path.replacingOccurrences(of: "~", with: homeDirectory)
        } else if path.hasPrefix("/") {
            // Absolute path - check if it's within our sandbox
            if path.hasPrefix(homeDirectory) {
                return path
            } else {
                return homeDirectory
            }
        } else {
            return "\(currentDirectory)/\(path)"
        }
    }
    
    @discardableResult
    private func createDirectoryIfNeeded(at path: String) -> Bool {
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                return false
            }
        }
        return true
    }
}
