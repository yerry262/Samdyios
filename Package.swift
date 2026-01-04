// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlpineOS",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AlpineOS",
            targets: ["AlpineOS"]),
    ],
    targets: [
        .target(
            name: "AlpineOS",
            path: "AlpineOS",
            exclude: [
                "Info.plist",
                "Resources/Assets.xcassets"
            ],
            sources: [
                ".",
                "Views",
                "Services"
            ]
        )
    ]
)
