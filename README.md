# Admin Panel Nodes SSO 🔒
[![Swift Version](https://img.shields.io/badge/Swift-3.1-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)
[![Linux Build Status](https://img.shields.io/circleci/project/github/nodes-vapor/admin-panel-nodes-sso.svg?label=Linux)](https://circleci.com/gh/nodes-vapor/admin-panel-nodes-sso)
[![macOS Build Status](https://img.shields.io/travis/nodes-vapor/admin-panel-nodes-sso.svg?label=macOS)](https://travis-ci.org/nodes-vapor/admin-panel-nodes-sso)
[![codebeat badge](https://codebeat.co/badges/52c2f960-625c-4a63-ae63-52a24d747da1)](https://codebeat.co/projects/github-com-nodes-vapor-admin-panel-nodes-sso)
[![codecov](https://codecov.io/gh/nodes-vapor/admin-panel-nodes-sso/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/admin-panel-nodes-sso)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/admin-panel-nodes-sso)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/admin-panel-nodes-sso)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/admin-panel-nodes-sso/master/LICENSE)


## 📦 Installation

Update your `Package.swift` file.
```swift
.Package(url: "https://github.com/nodes-vapor/admin-panel-nodes-sso.git", majorVersion: 0)
```


## Getting started 🚀

```swift
import AdminPanelNodesSSO
```

Add NodesSSO as SSOProvider when adding AdminPanel.Provider

```swift
try drop.addProvider(AdminPanel.Provider(drop: drop, ssoProvider: NodesSSO(droplet: drop)))
```

Make sure configs are added to `adminpanel.json`:

```json
"ssoRedirectUrl": "$SSO_REDIRECT_URL",
"ssoCallbackPath": "$SSO_CALLBACK_PATH",
"nodesSSOSalt": "$NODES_SSO_SALT",
```

(Note these 3 vars will be replaced in deployment)

The `nodes.png` goes into `Public/images/`.


## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodes.dk).
The package owner for this project is [Steffen](https://github.com/steffendsommer).

## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
