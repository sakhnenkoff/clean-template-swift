// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LocalPersistance",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "LocalPersistance",
            targets: ["LocalPersistance"]
        ),
        .library(
            name: "LocalPersistanceMock",
            targets: ["LocalPersistanceMock"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "LocalPersistance",
            dependencies: [
                .product(name: "SwiftKeychainWrapper", package: "SwiftKeychainWrapper")
            ]
        ),
        .target(
            name: "LocalPersistanceMock",
            dependencies: ["LocalPersistance"]
        ),
        .testTarget(
            name: "LocalPersistanceTests",
            dependencies: ["LocalPersistance", "LocalPersistanceMock"]
        )
    ]
)
