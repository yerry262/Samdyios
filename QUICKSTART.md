# Quick Start Guide

Welcome to AlpineOS! This guide will help you get started with the app quickly.

## 🚀 5-Minute Quick Start

### Step 1: Build and Run (1 minute)

```bash
# Clone the repository
git clone https://github.com/yerry262/Samdyios.git
cd Samdyios

# Open in Xcode
open AlpineOS.xcodeproj

# Press Cmd+R to build and run
```

### Step 2: Try the Terminal (2 minutes)

Once the app launches, you'll see the terminal tab. Try these commands:

```bash
# See available commands
help

# List files
ls

# Check current directory
pwd

# Create a new directory
mkdir myproject

# Navigate into it
cd myproject

# Create a file
touch hello.txt

# Add content with echo (simulated file write)
echo Hello from AlpineOS!

# Go back
cd ..

# List to see your new directory
ls
```

### Step 3: Browse Files (1 minute)

1. Tap the **Files** tab at the bottom
2. You'll see the Alpine file system
3. Tap folders to navigate
4. Tap the **+** button to create new files/folders
5. Tap a file to view its contents
6. Swipe left on items to delete them

### Step 4: Customize Settings (1 minute)

1. Tap the **Settings** tab
2. Adjust the font size slider
3. Explore the About screen
4. Check storage usage
5. View installed packages

## 📱 Common Tasks

### Create a Project Directory

```bash
cd ~
mkdir projects
cd projects
mkdir myapp
cd myapp
touch main.swift
```

### Browse System Structure

```bash
ls /
cd bin
ls
cd ../etc
ls
```

### Use Package Manager (Simulated)

```bash
# Update package index
apk update

# List installed packages
apk list

# Search for a package
apk search vim

# Install a package (simulated)
apk add vim

# Remove a package (simulated)
apk del vim
```

### View System Information

```bash
# OS name
uname

# Full system info
uname -a

# Current date and time
date

# Current user
whoami
```

### File Operations

```bash
# Create files
touch file1.txt file2.txt file3.txt

# List them
ls

# Copy a file
cp file1.txt file1_backup.txt

# Move/rename a file
mv file2.txt renamed.txt

# View file content
cat file1.txt

# Remove a file
rm file3.txt
```

## 💡 Tips and Tricks

### Terminal

- **Clear screen**: Type `clear` or tap the trash icon
- **Stop command**: Tap the stop icon (simulated Ctrl+C)
- **Auto-scroll**: Terminal automatically scrolls to latest output
- **Command recall**: Type the same command again (history coming soon!)

### File Browser

- **Quick delete**: Swipe left on any file or folder
- **Go up**: Tap the ".." entry at the top of the list
- **View path**: Current path shown at the top
- **Create items**: Tap the "+" button in toolbar

### Settings

- **Font size**: Adjust for better readability
- **Storage**: Monitor app storage usage
- **Cache**: Clear temporary files if needed

## 🎯 Example Workflows

### Workflow 1: Create a Shell Script

```bash
# Create a scripts directory
mkdir scripts
cd scripts

# Create a script file
touch hello.sh

# View it (would be empty)
cat hello.sh

# Note: Actual editing would be done in a future version
# For now, files can be created and managed
```

### Workflow 2: Organize Your Files

```bash
# Create an organized structure
mkdir -p projects/web
mkdir -p projects/mobile
mkdir -p documents/notes

# Navigate and create files
cd projects/web
touch index.html
touch style.css

cd ../mobile
touch app.swift

cd ../../documents/notes
touch ideas.txt
```

### Workflow 3: Explore the System

```bash
# Start from home
cd ~

# Look around
ls

# Check each directory
ls bin
ls etc
ls usr
ls tmp

# See the welcome file
cat README.txt
```

## ⚠️ Limitations to Know

1. **No Real Editing**: Files can be created but not edited in-place yet
2. **Simulated Commands**: Commands use iOS APIs, not actual Linux
3. **No Network**: Package installation and network commands are simulated
4. **Sandboxed**: All files are within the app's container
5. **No Root**: You're always in user space

## 🆘 Troubleshooting

### App Won't Build
- Update Xcode to 14.0+
- Check iOS deployment target (15.0+)
- Clean build folder (Cmd+Shift+K)

### Command Not Found
- Type `help` to see available commands
- Check spelling and syntax
- Some Linux commands aren't implemented yet

### File Not Found
- Use `pwd` to check current directory
- Use `ls` to see available files
- Use full paths starting with `/` or `~`

### Settings Not Saving
- Settings are saved automatically
- Restart app to see persisted settings
- Check app permissions in iOS Settings

## 📚 Learn More

- **Full documentation**: See [README.md](README.md)
- **Build instructions**: See [BUILDING.md](BUILDING.md)
- **Architecture**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)

## 🎓 Next Steps

After completing this quick start:

1. **Explore**: Try different commands and create your file structure
2. **Customize**: Adjust settings to your preference
3. **Contribute**: Found a bug or want a feature? Contribute!
4. **Share**: Star the repo if you find it useful

## 💬 Need Help?

- Open an issue on GitHub
- Check existing issues for solutions
- Read the full documentation
- Contribute improvements

---

**Happy Terminal-ing on iOS!** 🎉
