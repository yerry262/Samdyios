//
//  FileManagerView.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import SwiftUI

struct FileManagerView: View {
    @EnvironmentObject var fileSystemManager: FileSystemManager
    @State private var currentPath: String = "~"
    @State private var showingNewFileAlert = false
    @State private var showingNewFolderAlert = false
    @State private var newItemName = ""
    @State private var selectedFile: FileItem?
    @State private var showingFileViewer = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Current path
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.blue)
                    Text(currentPath)
                        .font(.system(.body, design: .monospaced))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                
                // File list
                List {
                    if currentPath != "/" && currentPath != "~" {
                        Button(action: navigateUp) {
                            HStack {
                                Image(systemName: "arrow.up")
                                Text("..")
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                    }
                    
                    ForEach(fileSystemManager.listFiles(at: currentPath), id: \.name) { item in
                        FileRow(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if item.isDirectory {
                                    navigateTo(item)
                                } else {
                                    selectedFile = item
                                    showingFileViewer = true
                                }
                            }
                    }
                    .onDelete(perform: deleteFiles)
                }
                .listStyle(.plain)
            }
            .navigationTitle("File Browser")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingNewFileAlert = true }) {
                            Label("New File", systemImage: "doc")
                        }
                        Button(action: { showingNewFolderAlert = true }) {
                            Label("New Folder", systemImage: "folder.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New File", isPresented: $showingNewFileAlert) {
                TextField("File name", text: $newItemName)
                Button("Cancel", role: .cancel) {
                    newItemName = ""
                }
                Button("Create") {
                    createFile()
                }
            }
            .alert("New Folder", isPresented: $showingNewFolderAlert) {
                TextField("Folder name", text: $newItemName)
                Button("Cancel", role: .cancel) {
                    newItemName = ""
                }
                Button("Create") {
                    createFolder()
                }
            }
            .sheet(isPresented: $showingFileViewer) {
                if let file = selectedFile {
                    FileViewerSheet(file: file)
                }
            }
        }
    }
    
    private func navigateUp() {
        currentPath = fileSystemManager.parentDirectory(of: currentPath)
    }
    
    private func navigateTo(_ item: FileItem) {
        currentPath = item.path
    }
    
    private func createFile() {
        guard !newItemName.isEmpty else { return }
        fileSystemManager.createFile(name: newItemName, at: currentPath)
        newItemName = ""
    }
    
    private func createFolder() {
        guard !newItemName.isEmpty else { return }
        fileSystemManager.createDirectory(name: newItemName, at: currentPath)
        newItemName = ""
    }
    
    private func deleteFiles(at offsets: IndexSet) {
        let files = fileSystemManager.listFiles(at: currentPath)
        for index in offsets {
            if index < files.count {
                fileSystemManager.deleteItem(at: files[index].path)
            }
        }
    }
}

struct FileRow: View {
    let item: FileItem
    
    var body: some View {
        HStack {
            Image(systemName: item.isDirectory ? "folder.fill" : "doc.text")
                .foregroundColor(item.isDirectory ? .blue : .gray)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(.body, design: .monospaced))
                
                HStack {
                    Text(item.formattedSize)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !item.isDirectory {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(item.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct FileViewerSheet: View {
    let file: FileItem
    @Environment(\.dismiss) var dismiss
    @State private var fileContent: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(fileContent)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle(file.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadFileContent()
            }
        }
    }
    
    private func loadFileContent() {
        if let content = FileSystemManager.shared.readFile(at: file.path) {
            fileContent = content
        } else {
            fileContent = "Unable to read file"
        }
    }
}

struct FileManagerView_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerView()
            .environmentObject(FileSystemManager.shared)
    }
}
