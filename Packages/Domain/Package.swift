// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
        .library(
            name: "DomainMock",
            targets: ["DomainMock"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftfulThinking/IdentifiableByString.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                .product(name: "IdentifiableByString", package: "IdentifiableByString")
            ]
        ),
        .target(
            name: "DomainMock",
            dependencies: ["Domain"]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain", "DomainMock"]
        )
    ]
)
