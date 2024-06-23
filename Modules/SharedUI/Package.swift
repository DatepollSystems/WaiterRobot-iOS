// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        ),
    ],
    targets: [
        .target(
            name: "SharedUI",
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "SharedUITests",
            dependencies: ["SharedUI"]
        ),
    ]
)
