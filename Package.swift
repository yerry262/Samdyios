// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// NOTE: This Package.swift is provided for reference and code organization purposes only.
// AlpineOS is an iOS application and should be built using the Xcode project (AlpineOS.xcodeproj).
// 
// To build this app:
// 1. Open AlpineOS.xcodeproj in Xcode on macOS
// 2. Select your target device or simulator
// 3. Press Cmd+R to build and run
//
// See BUILDING.md for detailed build instructions.

import PackageDescription

let package = Package(
    name: "AlpineOS",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // This is an iOS app, not a library
        // The product is defined in the Xcode project
    ],
    targets: [
        // Targets are managed by the Xcode project
        // This Package.swift exists for Swift Package Manager compatibility only
    ]
)
