// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WrappedMediaPlayer",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "WrappedMediaPlayer", targets: ["WrappedMediaPlayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OtoFlow/MPVKit.git", branch: "player"),
    ],
    targets: [
        .target(
            name: "WrappedMediaPlayer",
            dependencies: [
                .product(name: "MPVKit", package: "MPVKit"),
            ],
            path: "Sources"
        ),
    ]
)
