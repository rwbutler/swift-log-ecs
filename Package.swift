// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-log-ecs",
    products: [
        .library(
            name: "SwiftECSLogging",
            targets: ["swift-log-ecs"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "SwiftECSLogging",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "SwiftECSLoggingTests",
            dependencies: ["swift-log-ecs"]),
    ]
)
