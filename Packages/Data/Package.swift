// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
        .library(
            name: "DataMock",
            targets: ["DataMock"]
        )
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Networking", package: "Networking")
            ]
        ),
        .target(
            name: "DataMock",
            dependencies: ["Data"]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data", "DataMock"]
        )
    ]
)
