//
//  TerminalView.swift
//  AlpineOS
//
//  Created by AlpineOS Team
//

import SwiftUI

struct TerminalView: View {
    @EnvironmentObject var terminalEmulator: TerminalEmulator
    @State private var command: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Terminal output area
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(Array(terminalEmulator.outputLines.enumerated()), id: \.offset) { index, line in
                                Text(line)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(terminalEmulator.getColorForLine(line))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .id(index)
                            }
                        }
                        .padding(8)
                    }
                    .background(Color.black)
                    .onChange(of: terminalEmulator.outputLines.count) { _ in
                        // Auto-scroll to bottom when new output appears
                        if let lastIndex = terminalEmulator.outputLines.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Command input area
                HStack(spacing: 8) {
                    Text(terminalEmulator.currentPrompt)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                    
                    TextField("Enter command", text: $command)
                        .font(.system(.body, design: .monospaced))
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isInputFocused)
                        .onSubmit {
                            executeCommand()
                        }
                }
                .padding(8)
                .background(Color(UIColor.systemGray6))
            }
            .navigationTitle("Alpine OS Terminal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        terminalEmulator.clearScreen()
                    }) {
                        Image(systemName: "trash")
                    }
                    
                    Button(action: {
                        terminalEmulator.interruptCurrentProcess()
                    }) {
                        Image(systemName: "stop.circle")
                    }
                }
            }
        }
        .onAppear {
            isInputFocused = true
        }
    }
    
    private func executeCommand() {
        guard !command.isEmpty else { return }
        
        // Add command to output
        terminalEmulator.addOutput("\(terminalEmulator.currentPrompt)\(command)")
        
        // Execute command
        terminalEmulator.executeCommand(command)
        
        // Clear input
        command = ""
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        TerminalView()
            .environmentObject(TerminalEmulator())
    }
}
