#!/bin/bash
#
# Build script for AlpineOS iOS App
# This script should be run on macOS with Xcode installed
#

set -e

echo "🏗️  Building AlpineOS..."
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This build script must be run on macOS with Xcode installed"
    exit 1
fi

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store"
    exit 1
fi

# Print Xcode version
echo "📱 Xcode version:"
xcodebuild -version
echo ""

# Clean build directory
echo "🧹 Cleaning build directory..."
rm -rf build/
echo ""

# Build the project
echo "🔨 Building AlpineOS for iOS..."
xcodebuild \
    -project AlpineOS.xcodeproj \
    -scheme AlpineOS \
    -sdk iphoneos \
    -configuration Release \
    -derivedDataPath build \
    clean build

echo ""
echo "✅ Build completed successfully!"
echo "📦 Build artifacts are in the build/ directory"
