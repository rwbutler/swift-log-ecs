// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-log-ecs",
    products: [
        .library(
            name: "ECSLogging",
            targets: ["ECSLogging"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "ECSLogging",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "ECSLoggingTests",
            dependencies: ["ECSLogging"]),
    ]
)
