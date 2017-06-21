# Admin Panel Nodes SSO
[![Language](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
[![Build Status](https://api.travis-ci.org/nodes-vapor/admin-panel-nodes-sso.svg?branch=master)](https://travis-ci.org/nodes-vapor/admin-panel-nodes-sso)
[![codecov](https://codecov.io/gh/nodes-vapor/admin-panel-nodes-sso/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/admin-panel-nodes-sso)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/sugar/master/LICENSE)

## Integration
Update your `Package.swift` file.
```swift
.Package(url: "https://github.com/nodes-vapor/admin-panel-nodes-sso.git", majorVersion: 0)
```

```
import AdminPanelNodesSSO
```

Add NodesSSO as SSOProvider when adding AdminPanel.Provider

```
try drop.addProvider(AdminPanel.Provider(drop: drop, ssoProvider: NodesSSO(droplet: drop)))
```

Make sure configs are added / setup
adminpanel.json

```
"ssoRedirectUrl": "$SSO_REDIRECT_URL",
"ssoCallbackPath": "$SSO_CALLBACK_PATH",
"nodesSSOSalt": "$NODES_SSO_SALT",
```

(Note these 3 vars will be replaced in deployment)

Public the nodes.png into Public/images/

###
Note this package is also used for prototyping features before making PRs to Vapor

## 🏆 Credits
This package is developed and maintained by the Vapor team at [Nodes](https://www.nodes.dk).

## 📄 License
This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
