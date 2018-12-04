# Nodes SSO 🔑
[![Swift Version](https://img.shields.io/badge/Swift-4.1-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-30B6FC.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/nodes-sso/tree/master.svg?style=shield)](https://circleci.com/gh/nodes-vapor/nodes-sso)
[![codebeat badge](https://codebeat.co/badges/406e7fbd-e288-4020-b93f-92b518d60199)](https://codebeat.co/projects/github-com-nodes-vapor-nodes-sso-master)
[![codecov](https://codecov.io/gh/nodes-vapor/nodes-sso/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/nodes-sso)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/nodes-sso)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/nodes-sso)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/nodes-sso/master/LICENSE)

## 📦 Installation

Add `NodesSSO` to the package dependencies (in your `Package.swift` file):
```swift
dependencies: [
    ...,
    .package(url: "https://github.com/nodes-vapor/nodes-sso.git", from: "1.0.0-rc")
]
```

as well as to your target (e.g. "App"):

```swift
targets: [
    ...
    .target(
        name: "App",
        dependencies: [... "NodesSSO" ...]
    ),
    ...
]
```

### Install resources
Copy the `NodesSSO` folders from `Resources/Views` and `Public` from this repo and paste them into your project into the same directories. You can download this repo as a zip and then move the files into the mentioned directories.

## 🚀 Getting started

First make sure that you've imported NodesSSO everywhere it's needed:

```swift
import NodesSSO
```

### Adding the provider

```swift
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(NodesSSOProvider<MyNodesSSOAuthenticatableUser>(config: NodesSSOConfig(
        projectURL: "https://myproject.com",
        redirectURL: "https://url-for-sso.com",
        salt: "MY-SECRET-HASH-FOR-SSO",
        environment: env
    )))
}
```

There are also parameters for setting the routes that should enable SSO in your project. Have a look at the signature of `NodesSSOConfig` for more information.

### Adding the SSO routes

Make sure to add the relevant Nodes SSO routes, e.g. in your `configure.swift` or `routes.swift`:

```swift
services.register(Router.self) { container -> EngineRouter in
    let router = EngineRouter.default()
    try router.useNodesSSORoutes(MyNodesSSOAuthenticatableUser.self, on: container)
    return router
}
```

### Adding the Leaf tag

In order to render embed the SSO button, you will need to add the NodesSSO Leaf tag:

```swift
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    services.register { _ -> LeafTagConfig in
        var tags = LeafTagConfig.default()
        tags.useNodesSSOLeafTags()
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

The `NodesSSOProvider` is generic and requires a type that conforms to `NodesSSOAuthenticatable`. This protocol has one method that gets called when the SSO has finnished successfully:

```swift
public static func authenticated(_ user: AuthenticatedUser, req: Request) -> Future<Response>
```

Given this `AuthenticatedUser` the implementer can then look up the `email` and create the user if it doesn't exist, or if it does, log the user in automatically.

## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodes.dk).
The package owner for this project is [Steffen](https://github.com/steffendsommer).

## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
