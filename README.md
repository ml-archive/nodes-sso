# Nodes SSO 🔑
[![Swift Version](https://img.shields.io/badge/Swift-4.1-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-30B6FC.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/sugar/tree/master.svg?style=shield)](https://circleci.com/gh/nodes-vapor/sugar)
[![codebeat badge](https://codebeat.co/badges/fa667bac-85c1-4776-aaef-fdfea294e2c9)](https://codebeat.co/projects/github-com-nodes-vapor-admin-panel-nodes-sso-master)
[![codecov](https://codecov.io/gh/nodes-vapor/admin-panel-nodes-sso/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/admin-panel-nodes-sso)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/admin-panel-nodes-sso)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/admin-panel-nodes-sso)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/admin-panel-nodes-sso/master/LICENSE)

## 📦 Installation

Update your `Package.swift` file.

```swift
.package(url: "https://github.com/nodes-vapor/nodes-sso.git", from: "1.0.0-beta")
```
```swift
targets: [
    .target(
        name: "App",
        dependencies: [
            ...
            "NodesSSO"
        ]
    ),
    ...
]
```

### Install resources
Copy the `NodesSSO` folders from `Resources/Views` and `Public` from this repo and paste them into your project into the same directories. You can download this repo as a zip and then move the files into the mentioned directories.

## 🚀 Getting started

```swift
import NodesSSO
```

### Adding the provider

```swift
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(NodesSSOProvider<AdminPanelUser>(config: NodesSSOConfig(
        projectURL: "https://myproject.com",
        redirectURL: "https://url-for-sso.com",
        salt: "MY-SECRET-HASH-FOR-SSO",
        environment: env
    )))
}
```

There's also parameters for setting the routes that should enable SSO in your project. Have a look at the signature of `NodesSSOConfig` for more information.

### Adding the Leaf tag

#### Using a shared Leaf tag config

This package supports using a shared Leaf tag config which removes the task of registering the tags from the consumer of this package. Please see [this description](https://github.com/nodes-vapor/sugar#mutable-leaf-tag-config) if you want to use this.

#### Manually registering the Leaf tag(s)

In order to render embed the SSO button, you will need to add the NodesSSO Leaf tag:

```swift
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    services.register { _ -> LeafTagConfig in
        var tags = LeafTagConfig.default()
        tags.use(NodesSSOConfigTag(), as: "nodessso:config")
        return tags
    }
}
```

### Embedding the SSO button
On the page you want the NodesSSO button to appear, embed the `sso-button` leaf file:

```
#embed("NodesSSO/sso-button")
```

## Conforming to `NodesSSOAuthenticatable`

The `NodesSSOProvider` is generic and requires a type that conforms to `NodesSSOAuthenticatable`. This protocol has one method that gets called when the SSO is successfully done:

```swift
public static func authenticated(_ user: AuthenticatedUser, req: Request) -> Future<Response>
```

Given this `AuthenticatedUser` the implementer can then look up the `email` and create the user if it doesn't exist, or if it does, login the user automatically.

## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodes.dk).
The package owner for this project is [Steffen](https://github.com/steffendsommer).

## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
