// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "NodesSSO",
    products: [
        .library(name: "NodesSSO", targets: ["NodesSSO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/nodes-vapor/admin-panel.git", .branch("vapor-3")),
    ],
    targets: [
        .target(name: "NodesSSO", dependencies: ["Vapor", "AdminPanel"]),
        .testTarget(name: "NodesSSOTests", dependencies: ["NodesSSO"]),
    ]
)
