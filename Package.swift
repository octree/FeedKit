// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .tvOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(name: "FeedKit", targets: ["FeedKit"])
    ],
    targets: [
        .target(name: "FeedKit", dependencies: []),
        .testTarget(name: "Tests",
                    dependencies: ["FeedKit"],
                    path: "Tests",
                    resources: [
                        .process("xml"),
                        .process("json")
                    ])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
