import Vapor
import AdminPanelProvider

public final class Provider: Vapor.Provider {
    public static let repositoryName = "nodes-vapor/admin-panel-sso-nodes-provider"
    private var config: AdminPanelNodesSSO.Config!

    public init() {}

    public convenience init(config: Vapor.Config) throws {
        self.init()
    }

    public func boot(_ config: Vapor.Config) throws {
        self.config = try AdminPanelNodesSSO.Config(config)

        let middleware = ConfigMiddleware(loginPath: self.config.loginPath)
        Middlewares.unsecured.append(middleware)
    }

    public func boot(_ droplet: Droplet) throws {
        let hasher = CryptoHasher(hash: .sha256, encoding: .hex)
        let controller = LoginController(
            environment: config.environment,
            hasher: hasher,
            salt: config.salt,
            callbackPath: config.callbackPath,
            redirectUrl: config.redirectUrl
        )
        let ssoRoutes = LoginRoutes(
            loginPath: config.loginPath,
            callbackPath: config.callbackPath,
            controller: controller
        )

        try droplet.collection(ssoRoutes)
    }

    public func beforeRun(_ droplet: Droplet) throws {}
}
