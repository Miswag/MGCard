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
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.6.0")
    ],
    targets: [
        .target(
            name: "MGCard",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm")
            ],
            resources: []
        )
    ]
)
