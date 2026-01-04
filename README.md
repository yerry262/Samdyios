# AlpineOS - Alpine Linux on iOS

<div align="center">

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A complete iOS application that allows users to run Alpine OS Linux environment on iOS devices.

</div>

## 📱 Features

- **Full Terminal Emulator**: Complete VT100/ANSI terminal with command input and output display
- **File System Management**: Sandboxed Linux file system with create, read, write, and delete operations
- **Unix Command Support**: Includes common commands like `ls`, `cd`, `mkdir`, `cat`, `rm`, `cp`, `mv`, and more
- **Package Manager**: Alpine's `apk` package manager interface (simulated)
- **SwiftUI Interface**: Modern, intuitive user interface with tab-based navigation
- **Process Management**: Execute and manage Linux processes within the iOS sandbox
- **Settings & Configuration**: Customizable terminal settings and system information

## 🎯 Project Structure

```
AlpineOS/
├── AlpineOS.xcodeproj/          # Xcode project configuration
├── AlpineOS/
│   ├── AlpineOSApp.swift        # App entry point
│   ├── Info.plist               # App configuration
│   ├── Views/                   # SwiftUI views
│   │   ├── ContentView.swift    # Main navigation
│   │   ├── TerminalView.swift   # Terminal interface
│   │   ├── FileManagerView.swift # File browser
│   │   └── SettingsView.swift   # Settings & about
│   ├── Services/                # Core functionality
│   │   ├── TerminalEmulator.swift    # Terminal emulation
│   │   ├── CommandExecutor.swift     # Command execution
│   │   ├── FileSystemManager.swift   # File operations
│   │   └── ProcessManager.swift      # Process control
│   └── Resources/               # Assets and resources
│       └── Assets.xcassets/
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- macOS 12.0 or later
- Xcode 14.0 or later
- iOS 15.0+ device or simulator

### Building the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/yerry262/Samdyios.git
   cd Samdyios
   ```

2. **Open in Xcode**
   ```bash
   open AlpineOS.xcodeproj
   ```

3. **Select your target**
   - Choose your iOS device or simulator from the scheme selector
   - Set the development team in "Signing & Capabilities"

4. **Build and Run**
   - Press `Cmd + R` or click the Run button
   - The app will build and launch on your selected device

### Installation on Device

1. Connect your iOS device to your Mac
2. Trust your device when prompted
3. Select your device in Xcode
4. Build and run the project
5. On your device, go to Settings > General > VPN & Device Management
6. Trust the developer certificate

## 📖 Usage Guide

### Terminal Commands

The terminal supports a variety of Unix-like commands:

#### File Operations
```bash
ls [path]           # List directory contents
cd [path]           # Change directory
pwd                 # Print working directory
mkdir <name>        # Create directory
touch <name>        # Create file
rm <file>           # Remove file
cat <file>          # Display file contents
cp <src> <dst>      # Copy file
mv <src> <dst>      # Move/rename file
echo <text>         # Print text
```

#### System Commands
```bash
clear               # Clear terminal screen
help                # Show available commands
uname               # Display system information
date                # Show current date and time
whoami              # Print current user
```

#### Package Management
```bash
apk update          # Update package index
apk search <pkg>    # Search for packages
apk add <pkg>       # Install package (simulated)
apk del <pkg>       # Remove package (simulated)
apk list            # List installed packages
```

### File Browser

- Navigate through the sandboxed file system
- Create new files and folders
- View file contents
- Delete items (swipe left on items)
- Supports both iPhone and iPad layouts

### Settings

- Adjust terminal font size
- Toggle dark mode
- Access package manager
- View system information
- Check storage usage

## 🏗️ Technical Architecture

### SwiftUI App Structure

The app is built using modern SwiftUI patterns:

- **MVVM Architecture**: Clear separation between views and business logic
- **Environment Objects**: Shared state management across views
- **Combine Framework**: Reactive programming for asynchronous operations

### Terminal Emulation

The terminal emulator provides:

- Line-based output buffering
- Color support for error/warning messages
- Command history and execution
- Process interruption (Ctrl+C simulation)

### File System

The file system is implemented within iOS app sandbox:

- **Home Directory**: `~/alpine/` within app's Documents
- **Directory Structure**: Unix-like hierarchy (`bin`, `etc`, `home`, `tmp`, `usr`, `var`)
- **Permissions**: All operations sandboxed to app's container
- **Storage**: Files persist between app launches

### Command Execution

Commands are executed through a routing system:

1. User input parsed into command and arguments
2. Command router directs to appropriate handler
3. Handler performs operation using FileSystemManager
4. Output returned to terminal display

## 🛠️ Technical Implementation Details

### iOS Frameworks Used

- **SwiftUI**: Modern declarative UI framework
- **Foundation**: File operations, data handling
- **Combine**: Reactive event handling
- **UIKit**: Low-level iOS integration (bridged)

### Limitations

Due to iOS sandbox restrictions:

- No actual Linux kernel or virtualization
- Commands are simulated using iOS APIs
- Package installation is simulated (no actual apk support)
- Process management limited to iOS Process API
- No network access to external repositories

### Performance Considerations

- Lightweight implementation suitable for mobile devices
- Efficient memory management with SwiftUI
- Lazy loading of file system contents
- Optimized terminal output buffering

## 🎨 Screenshots

*The app features a clean, modern interface with:*

- **Terminal Tab**: Full-screen terminal with command input
- **Files Tab**: Browse and manage your file system
- **Settings Tab**: Configure app preferences

## 🔄 Future Enhancements

Potential improvements for future versions:

- [ ] Actual Alpine Linux rootfs integration
- [ ] QEMU-based ARM emulation
- [ ] Real package installation support
- [ ] SSH/SFTP client integration
- [ ] Script editor with syntax highlighting
- [ ] Tab support for multiple terminal sessions
- [ ] Clipboard integration
- [ ] External keyboard shortcuts
- [ ] iCloud sync for files

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

This project was inspired by:

- [**iSH**](https://github.com/ish-app/ish): Alpine Linux shell for iOS
- [**A-shell**](https://github.com/holzschu/a-shell): Unix shell for iOS
- **Blink Shell**: Professional terminal for iOS
- **Alpine Linux**: Lightweight Linux distribution

## 📞 Contact & Support

- **Issues**: Report bugs and request features via [GitHub Issues](https://github.com/yerry262/Samdyios/issues)
- **Repository**: [https://github.com/yerry262/Samdyios](https://github.com/yerry262/Samdyios)

## ⚠️ Disclaimer

This app provides a simulated Alpine Linux environment within iOS sandbox constraints. It is designed for educational purposes and light terminal work. For full Linux functionality, consider using actual Linux systems or virtualization solutions.

---

<div align="center">

Made with ❤️ for the iOS and Linux communities

**Star ⭐ this repository if you find it useful!**

</div>
