// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MGCard",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "MGCard",
            targets: ["MGCard"]
        ),
    ],
    dependencies: [
        // No external dependencies - keeping it lightweight
    ],
    targets: [
        .target(
            name: "MGCard",
            dependencies: [],
            resources: []
        )
    ]
) 
