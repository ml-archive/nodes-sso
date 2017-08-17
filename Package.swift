import PackageDescription

let package = Package(
    name: "AdminPanelNodesSSO",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/nodes-vapor/admin-panel.git", majorVersion: 1)
    ]
)
