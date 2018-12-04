// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "NodesSSO",
    products: [
        .library(name: "NodesSSO", targets: ["NodesSSO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nodes-vapor/sugar.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "NodesSSO", dependencies: ["Sugar", "Vapor"]),
        .testTarget(name: "NodesSSOTests", dependencies: ["NodesSSO"]),
    ]
)
