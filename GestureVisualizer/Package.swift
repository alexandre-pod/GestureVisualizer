// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "GestureVisualizer",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "GestureVisualizer",
            targets: ["GestureVisualizer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GestureVisualizer",
            dependencies: []
        )
    ]
)
