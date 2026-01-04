//
//  ContentView.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TerminalView()
                .tabItem {
                    Label("Terminal", systemImage: "terminal")
                }
                .tag(0)
            
            FileManagerView()
                .tabItem {
                    Label("Files", systemImage: "folder")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FileSystemManager.shared)
            .environmentObject(TerminalEmulator())
    }
}
