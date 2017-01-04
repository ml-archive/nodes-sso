import PackageDescription

let package = Package(
    name: "AdminPanelNodesSSO",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/nodes-vapor/admin-panel", majorVersion: 0)
    ]
)
