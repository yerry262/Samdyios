//
//  SettingsView.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("fontSize") private var fontSize: Double = 14.0
    @AppStorage("darkMode") private var darkMode: Bool = true
    @AppStorage("autoComplete") private var autoComplete: Bool = true
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Terminal")) {
                    HStack {
                        Text("Font Size")
                        Spacer()
                        Text("\(Int(fontSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $fontSize, in: 10...24, step: 1)
                    
                    Toggle("Auto-complete", isOn: $autoComplete)
                    
                    Toggle("Dark Mode", isOn: $darkMode)
                }
                
                Section(header: Text("Alpine Linux")) {
                    NavigationLink(destination: PackageManagerView()) {
                        Label("Package Manager", systemImage: "shippingbox")
                    }
                    
                    HStack {
                        Text("Alpine Version")
                        Spacer()
                        Text("v3.19")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Architecture")
                        Spacer()
                        Text("ARM64")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Storage")) {
                    HStack {
                        Text("Used Space")
                        Spacer()
                        Text(FileSystemManager.shared.getUsedSpace())
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: clearCache) {
                        Text("Clear Cache")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("About")) {
                    Button(action: { showingAbout = true }) {
                        Label("About AlpineOS", systemImage: "info.circle")
                    }
                    
                    Link(destination: URL(string: "https://github.com/yerry262/Samdyios")!) {
                        Label("GitHub Repository", systemImage: "link")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    private func clearCache() {
        FileSystemManager.shared.clearCache()
    }
}

struct PackageManagerView: View {
    @State private var installedPackages: [String] = ["bash", "coreutils", "busybox", "alpine-base"]
    @State private var searchText = ""
    
    var body: some View {
        List {
            Section(header: Text("Installed Packages")) {
                ForEach(installedPackages, id: \.self) { package in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(package)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
        .navigationTitle("Packages")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search packages")
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "terminal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .padding(.top, 40)
                    
                    Text("AlpineOS")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Alpine Linux on iOS")
                            .font(.headline)
                        
                        Text("A complete iOS application that allows users to run Alpine OS Linux environment on iOS devices. Features include a full terminal emulator, file system management, and package management.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "terminal", text: "Full VT100/ANSI Terminal")
                        FeatureRow(icon: "folder", text: "File System Management")
                        FeatureRow(icon: "shippingbox", text: "Package Manager (apk)")
                        FeatureRow(icon: "gearshape", text: "Process Management")
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
