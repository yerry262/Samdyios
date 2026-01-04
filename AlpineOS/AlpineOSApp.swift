//
//  AlpineOSApp.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import SwiftUI

@main
struct AlpineOSApp: App {
    @StateObject private var fileSystemManager = FileSystemManager.shared
    @StateObject private var terminalEmulator = TerminalEmulator()
    
    init() {
        // Initialize the Linux environment on app launch
        setupLinuxEnvironment()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fileSystemManager)
                .environmentObject(terminalEmulator)
        }
    }
    
    private func setupLinuxEnvironment() {
        // Create necessary directories for the Linux environment
        FileSystemManager.shared.initializeFileSystem()
    }
}
