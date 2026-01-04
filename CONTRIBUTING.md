# Contributing to AlpineOS

Thank you for your interest in contributing to AlpineOS! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:

1. **Clear title** - Summarize the issue
2. **Description** - Detailed explanation of the problem
3. **Steps to reproduce** - How to trigger the bug
4. **Expected behavior** - What should happen
5. **Actual behavior** - What actually happens
6. **Environment** - iOS version, device model, app version
7. **Screenshots** - If applicable

### Suggesting Features

Feature requests are welcome! Please include:

1. **Use case** - Why this feature is needed
2. **Description** - What the feature should do
3. **Mockups** - Visual examples if relevant
4. **Alternatives** - Other solutions you've considered

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yerry262/Samdyios.git
   cd Samdyios
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the code style guidelines below
   - Add comments for complex logic
   - Update documentation if needed

4. **Test your changes**
   - Build and run the app
   - Test on multiple iOS versions if possible
   - Verify no regressions

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: description"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template

## Code Style Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use clear, descriptive names for variables and functions
- Prefer `let` over `var` when possible
- Use type inference where it improves readability

#### Naming Conventions

```swift
// Classes and Structs - UpperCamelCase
class TerminalEmulator { }
struct FileItem { }

// Functions and Variables - lowerCamelCase
func executeCommand() { }
var currentDirectory: String

// Constants - lowerCamelCase
let homeDirectory: String

// Enums - UpperCamelCase for type, lowerCamelCase for cases
enum CommandError {
    case notFound
    case invalidArguments
}
```

#### Code Organization

```swift
// Use MARK: comments to organize code
class Example {
    // MARK: - Properties
    
    // MARK: - Initialization
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
}
```

### SwiftUI Style

- Extract complex views into separate components
- Use meaningful property names
- Prefer composition over complex view builders
- Use PreviewProvider for all views

```swift
// Good
struct TerminalView: View {
    var body: some View {
        VStack {
            TerminalOutput()
            TerminalInput()
        }
    }
}

// Avoid
struct TerminalView: View {
    var body: some View {
        VStack {
            // 100 lines of code...
        }
    }
}
```

### Documentation

- Add documentation comments for public APIs
- Explain "why" not just "what" in comments
- Update documentation when changing behavior

```swift
/// Executes a command in the terminal environment
/// - Parameter command: The command string to execute
/// - Returns: A Result containing output or an error
func executeCommand(_ command: String) -> Result<String, Error>
```

## Development Setup

### Requirements

- macOS 12.0+
- Xcode 14.0+
- iOS 15.0+ device or simulator

### Building

```bash
open AlpineOS.xcodeproj
# Select target and build (Cmd+B)
```

### Project Structure

```
AlpineOS/
├── Views/           # SwiftUI views
├── Services/        # Business logic
└── Resources/       # Assets and resources
```

## Testing Guidelines

### Manual Testing Checklist

Before submitting a PR, test:

- [ ] App launches without crashes
- [ ] Terminal input and output works
- [ ] File browser navigation works
- [ ] Settings persist correctly
- [ ] No memory leaks (use Instruments)
- [ ] Works on both iPhone and iPad
- [ ] Portrait and landscape orientations

### What to Test

1. **Terminal**
   - Command execution
   - Output display
   - Error handling
   - Clear function
   - Interrupt button

2. **File Browser**
   - Directory navigation
   - File creation
   - File deletion
   - File viewing
   - Path display

3. **Settings**
   - Font size changes
   - Setting persistence
   - About screen

## Areas for Contribution

### High Priority

- [ ] Actual Alpine Linux rootfs integration
- [ ] Improved terminal emulation (escape sequences)
- [ ] Command history (up/down arrows)
- [ ] Tab completion
- [ ] Multiple terminal tabs

### Medium Priority

- [ ] Syntax highlighting in file viewer
- [ ] Text editor
- [ ] Better error messages
- [ ] Performance optimizations
- [ ] Unit tests

### Low Priority

- [ ] Custom themes
- [ ] Keyboard shortcuts
- [ ] iCloud sync
- [ ] SSH client
- [ ] Script automation

## Questions?

If you have questions about contributing:

1. Check existing issues and PRs
2. Read the documentation (README, ARCHITECTURE)
3. Open a discussion issue
4. Ask in your PR

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes for significant contributions
- README credits section (for major features)

Thank you for contributing to AlpineOS! 🎉
