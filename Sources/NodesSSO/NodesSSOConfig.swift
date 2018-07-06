import Vapor

public struct NodesSSOConfig: Service {
    let projectURL: String
    let loginPath: String
    let redirectURL: String
    let callbackPath: String
    let salt: String
    let middlewares: [Middleware]
    let environment: Environment
    let skipSSO: Bool

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
    }
}
