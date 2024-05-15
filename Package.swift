// swift-tools-version:5.9
import PackageDescription

// this package is only for command line dependencies, not used for dependencies used by any targets
let package = Package(
    name: "CMDLineDependencies",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.40.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.53.8"),
    ]
)
