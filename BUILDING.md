# Building AlpineOS

## Prerequisites

Before building AlpineOS, ensure you have:

- **macOS 12.0 or later**
- **Xcode 14.0 or later** (available from the App Store)
- An **Apple Developer Account** (free account is sufficient for device testing)

## Build Methods

### Method 1: Using Xcode (Recommended)

1. **Open the project**
   ```bash
   cd Samdyios
   open AlpineOS.xcodeproj
   ```

2. **Configure signing**
   - Select the AlpineOS project in the Project Navigator
   - Select the AlpineOS target
   - Go to "Signing & Capabilities"
   - Select your development team

3. **Select a destination**
   - Choose an iOS Simulator (e.g., iPhone 14 Pro)
   - Or connect a physical iOS device

4. **Build and run**
   - Press `⌘ + R` or click the Run button (▶️)
   - Wait for the build to complete
   - The app will launch automatically

### Method 2: Using Command Line

1. **Using the build script**
   ```bash
   cd Samdyios
   ./build.sh
   ```

2. **Using xcodebuild directly**
   ```bash
   # For simulator
   xcodebuild -project AlpineOS.xcodeproj \
              -scheme AlpineOS \
              -sdk iphonesimulator \
              -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
              clean build

   # For device
   xcodebuild -project AlpineOS.xcodeproj \
              -scheme AlpineOS \
              -sdk iphoneos \
              -configuration Release \
              clean build
   ```

## Installing on a Physical Device

### Development Installation

1. **Connect your iOS device** to your Mac via USB

2. **Trust your computer**
   - On your iOS device, tap "Trust" when prompted

3. **Select your device in Xcode**
   - In the device selector, choose your connected device

4. **Build and run**
   - Press `⌘ + R`
   - Xcode will install and launch the app

5. **Trust the developer certificate**
   - On your device, go to Settings → General → VPN & Device Management
   - Find your developer certificate
   - Tap "Trust [Your Developer Name]"

### Archive for Distribution

To create an archive for distribution (App Store or Ad-Hoc):

1. **In Xcode, go to Product → Archive**

2. **Wait for the archive to complete**

3. **In the Organizer window:**
   - Select your archive
   - Click "Distribute App"
   - Choose your distribution method
   - Follow the prompts

## Troubleshooting

### Code Signing Issues

**Problem**: "Failed to code sign"

**Solution**:
- Ensure you're logged into Xcode with your Apple ID (Xcode → Settings → Accounts)
- Select your team in the project's Signing & Capabilities
- For device installation, ensure your device is registered with your developer account

### Build Failures

**Problem**: "No such module 'SwiftUI'"

**Solution**:
- Update Xcode to version 14.0 or later
- Ensure iOS Deployment Target is set to iOS 15.0 or later

**Problem**: "The operation couldn't be completed"

**Solution**:
- Clean the build folder: `⌘ + Shift + K`
- Delete derived data: `⌘ + Shift + Option + K`
- Restart Xcode

### Device Installation Issues

**Problem**: "Could not launch [App]"

**Solution**:
- Check that your device is unlocked
- Verify you've trusted the developer certificate in Settings
- Try disconnecting and reconnecting your device

## Development Tips

### Debugging

- Use `⌘ + \` to set breakpoints in Xcode
- View console output in Xcode's debug area (`⌘ + Shift + Y`)
- Use the SwiftUI Preview feature for quick UI iterations

### Performance

- Build in Release configuration for performance testing
- Use Instruments (⌘ + I) to profile the app
- Monitor memory usage in the Debug Navigator

### Testing

- Run unit tests: `⌘ + U`
- Test on multiple iOS versions and device sizes
- Use the Accessibility Inspector to verify accessibility

## Next Steps

After successfully building:

1. Read the [Usage Guide](README.md#usage-guide) to learn how to use the app
2. Explore the codebase and make modifications
3. Consider contributing improvements back to the project

## Need Help?

- Check the [main README](README.md) for general information
- Open an issue on GitHub if you encounter problems
- Review Apple's [Xcode documentation](https://developer.apple.com/xcode/)
