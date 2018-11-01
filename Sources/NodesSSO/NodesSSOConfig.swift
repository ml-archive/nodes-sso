import Vapor

public struct NodesSSOConfig<U: NodesSSOAuthenticatable>: Service {
    internal let projectURL: String
    internal let loginPath: String
    internal let redirectURL: String
    internal let callbackPath: String
    internal let salt: String
    internal let middlewares: [Middleware]
    internal let environment: Environment
    internal let skipSSO: Bool
    internal let controller: NodesSSOController<U>

    public init(
        projectURL: String,
        loginPath: String = "/sso/login",
        redirectURL: String,
        callbackPath: String = "/sso/callback",
        salt: String,
        middlewares: [Middleware] = [],
        environment: Environment,
        skipSSO: Bool = false
    ) {
        self.projectURL = projectURL
        self.loginPath = loginPath
        self.redirectURL = redirectURL
        self.callbackPath = callbackPath
        self.salt = salt
        self.middlewares = middlewares
        self.environment = environment
        self.skipSSO = skipSSO
        self.controller = NodesSSOController()
    }
}
