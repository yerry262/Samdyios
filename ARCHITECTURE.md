# AlpineOS Technical Architecture

## Overview

AlpineOS is a SwiftUI-based iOS application that simulates an Alpine Linux environment within the iOS sandbox. This document describes the technical architecture, design decisions, and implementation details.

## Architecture Diagram

```
┌─────────────────────────────────────────────┐
│           User Interface Layer              │
│                 (SwiftUI)                   │
├─────────────────────────────────────────────┤
│  ContentView  │ TerminalView │ FileManager │
│               │ SettingsView │             │
└──────────────┬──────────────┬──────────────┘
               │              │
               ▼              ▼
┌─────────────────────────────────────────────┐
│        EnvironmentObjects Layer             │
├─────────────────────────────────────────────┤
│  TerminalEmulator  │  FileSystemManager     │
└──────────────┬─────┴──────────┬─────────────┘
               │                │
               ▼                ▼
┌─────────────────────────────────────────────┐
│          Services Layer                     │
├─────────────────────────────────────────────┤
│  CommandExecutor  │  ProcessManager        │
└──────────────┬────┴────────────┬────────────┘
               │                 │
               ▼                 ▼
┌─────────────────────────────────────────────┐
│          iOS Foundation Layer               │
├─────────────────────────────────────────────┤
│  FileManager  │  Process  │  Foundation    │
└─────────────────────────────────────────────┘
```

## Core Components

### 1. Application Layer

#### AlpineOSApp.swift
- **Purpose**: Main application entry point
- **Responsibilities**:
  - App lifecycle management
  - Initialize global state objects
  - Set up the Linux environment on launch
  - Provide environment objects to views

**Key Features**:
```swift
@main struct AlpineOSApp: App
- Uses @StateObject for dependency injection
- Calls setupLinuxEnvironment() on init
- Provides environmentObject() modifiers
```

### 2. View Layer (SwiftUI)

#### ContentView.swift
- **Purpose**: Main navigation container
- **Pattern**: TabView-based navigation
- **Tabs**:
  1. Terminal - Command line interface
  2. Files - File browser
  3. Settings - Configuration

#### TerminalView.swift
- **Purpose**: Terminal emulator interface
- **Components**:
  - ScrollView for output display
  - TextField for command input
  - Toolbar with clear and interrupt buttons
- **Features**:
  - Auto-scroll to latest output
  - Monospaced font for terminal authenticity
  - Color-coded output (errors in red, etc.)
  - Focus management for keyboard input

#### FileManagerView.swift
- **Purpose**: File system browser
- **Components**:
  - List-based file browser
  - Current path display
  - File creation dialogs
  - File viewer sheet
- **Features**:
  - Navigation through directory hierarchy
  - Create files and folders
  - Delete items (swipe to delete)
  - View file contents
  - Sort: directories first, then alphabetically

#### SettingsView.swift
- **Purpose**: App configuration and information
- **Sections**:
  - Terminal settings (font size, theme)
  - Alpine Linux info (version, architecture)
  - Storage management
  - About screen
- **Features**:
  - @AppStorage for persistent settings
  - Package manager navigation
  - Storage usage display
  - About modal with app info

### 3. Service Layer

#### TerminalEmulator.swift
- **Purpose**: Terminal emulation logic
- **Pattern**: ObservableObject with @Published properties
- **State**:
  - `outputLines: [String]` - Terminal output buffer
  - `currentPrompt: String` - Command prompt display
- **Functions**:
  - `executeCommand(_:)` - Process user commands
  - `addOutput(_:)` - Append text to terminal
  - `clearScreen()` - Clear terminal display
  - `getColorForLine(_:)` - Colorize output
- **Design**: Uses Combine framework for reactive updates

#### CommandExecutor.swift
- **Purpose**: Command parsing and execution
- **Pattern**: Singleton with command routing
- **Supported Commands**:
  - File operations: ls, cd, pwd, mkdir, touch, rm, cat, cp, mv
  - System: uname, date, whoami, echo
  - Package management: apk (simulated)
- **Architecture**:
  ```
  execute(command:) → parse → route → handler → result
  ```
- **Error Handling**: Typed errors with CommandError enum

#### FileSystemManager.swift
- **Purpose**: File system operations within iOS sandbox
- **Pattern**: Singleton ObservableObject
- **File Structure**:
  ```
  Documents/alpine/          (home directory)
  ├── bin/                   (binaries - simulated)
  ├── etc/                   (configuration)
  ├── home/                  (user home)
  ├── tmp/                   (temporary files)
  ├── var/                   (variable data)
  └── usr/                   (user programs)
      ├── local/
      └── share/
  ```
- **Operations**:
  - Directory: create, list, navigate, delete
  - Files: create, read, write, delete, copy, move
  - Info: size, permissions, modification date
- **Security**: All operations restricted to app sandbox

#### ProcessManager.swift
- **Purpose**: Process lifecycle management
- **Pattern**: Singleton for process tracking
- **Features**:
  - Start processes with PID assignment
  - Kill/interrupt processes
  - List running processes
  - Signal handling (SIGINT, SIGTERM, SIGKILL)
- **Limitation**: Uses iOS Process API (limited compared to Linux)

## Data Flow

### Command Execution Flow

```
User Input → TerminalView
              ↓
      TerminalEmulator.executeCommand()
              ↓
      CommandExecutor.execute()
              ↓
    Parse command and arguments
              ↓
      Route to specific handler
              ↓
    FileSystemManager operations
              ↓
      Return result/output
              ↓
    TerminalEmulator.addOutput()
              ↓
      Update @Published property
              ↓
      SwiftUI view updates
```

### File Browser Flow

```
User navigates → FileManagerView
                       ↓
              Request file list
                       ↓
         FileSystemManager.listFiles()
                       ↓
            iOS FileManager API
                       ↓
          Return FileItem array
                       ↓
           Update view state
                       ↓
         Render in List view
```

## Design Patterns

### 1. MVVM (Model-View-ViewModel)
- **Views**: SwiftUI views (ContentView, TerminalView, etc.)
- **ViewModels**: ObservableObject classes (TerminalEmulator, FileSystemManager)
- **Models**: Data structures (FileItem, ProcessInfo, CommandError)

### 2. Singleton Pattern
- CommandExecutor.shared
- FileSystemManager.shared
- ProcessManager.shared
- Rationale: Single source of truth for system state

### 3. Dependency Injection
- Environment objects passed via `.environmentObject()`
- Shared between views without tight coupling

### 4. Command Pattern
- CommandExecutor routes commands to handlers
- Each command has its own handler function
- Easy to extend with new commands

### 5. Observer Pattern
- Combine framework with @Published properties
- Views automatically update when state changes
- Reactive data flow

## iOS Sandbox Considerations

### Limitations

1. **No Kernel Access**
   - Cannot run actual Linux kernel
   - No direct syscall access
   - Limited process control

2. **File System**
   - Restricted to app container
   - Cannot access system directories
   - No true Unix permissions

3. **Process Management**
   - iOS Process API limited
   - No fork/exec like Linux
   - Background execution limited

4. **Networking**
   - Network access requires entitlements
   - No raw socket access
   - Package repositories not accessible

### Solutions

1. **Command Simulation**
   - Implement commands using iOS APIs
   - FileManager for file operations
   - Process for limited execution

2. **Virtual File System**
   - Maintain Unix-like structure
   - Store in Documents directory
   - Preserve between launches

3. **Simulated Package Manager**
   - Mock apk commands
   - Pre-configure common packages
   - Could extend with actual downloads

## Performance Optimizations

1. **Lazy Loading**
   - File lists loaded on-demand
   - Terminal output buffered

2. **Efficient Rendering**
   - SwiftUI's automatic optimization
   - Only re-render changed views
   - Virtualized lists for large directories

3. **Memory Management**
   - Weak references to prevent cycles
   - Clear terminal output if too large
   - Cache clearing in settings

4. **Async Operations**
   - Command execution on background queue
   - UI updates on main queue
   - Non-blocking terminal input

## Security

1. **Sandboxing**
   - All operations within app container
   - No access to system files
   - User data protected by iOS

2. **Input Validation**
   - Command parsing with error handling
   - Path resolution prevents directory traversal
   - Safe file operations

3. **Error Handling**
   - Graceful failure for invalid operations
   - User-friendly error messages
   - No crash on bad input

## Testing Strategy

### Unit Tests (Future)
- CommandExecutor logic
- FileSystemManager operations
- Path resolution
- Command parsing

### UI Tests (Future)
- Terminal input/output
- File browser navigation
- Settings persistence

### Manual Testing
- Test on multiple iOS versions
- Various device sizes (iPhone/iPad)
- Different screen orientations
- Memory pressure scenarios

## Future Enhancements

### Near-term
1. Command history (up/down arrows)
2. Tab completion
3. Multiple terminal tabs
4. Script execution
5. Text editor integration

### Long-term
1. QEMU integration for actual Linux
2. Real Alpine rootfs
3. Network/SSH support
4. iCloud file sync
5. External keyboard shortcuts
6. Shortcuts app integration

## Development Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable names
- Comment complex logic
- Group related code with // MARK:

### SwiftUI Best Practices
- Prefer @State and @StateObject appropriately
- Extract views for reusability
- Use ViewModifiers for common styling
- Leverage PreviewProvider for development

### Git Workflow
- Feature branches for new features
- Descriptive commit messages
- Code review before merge
- Keep commits focused and atomic

## Dependencies

### System Frameworks
- **SwiftUI**: UI framework
- **Foundation**: Core utilities
- **Combine**: Reactive programming
- **UIKit**: iOS integration (bridged)

### Third-party (None currently)
- Potential: Terminal emulator library
- Potential: Syntax highlighting
- Potential: SSH library

## Build Configuration

### Deployment Target
- Minimum: iOS 15.0
- Reason: SwiftUI features used

### Capabilities
- File sharing enabled
- Documents browser enabled

### Build Settings
- Swift 5.0
- Optimization: -Onone (Debug), -O (Release)
- Code signing: Automatic

## Conclusion

AlpineOS demonstrates how to create a functional Linux-like terminal environment on iOS within sandbox constraints. The architecture is modular, maintainable, and extensible for future enhancements.
