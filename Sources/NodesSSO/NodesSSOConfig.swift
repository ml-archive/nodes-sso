import Vapor

public struct NodesSSOConfig: Service {
    let projectURL: String
    let loginPath: String
    let redirectURL: String
    let callbackPath: String
    let salt: String
    let middlewares: [Middleware]

    public init(
        projectURL: String,
        loginPath: String,
        redirectURL: String,
        callbackPath: String,
        salt: String,
        middlewares: [Middleware] = []
    ) {
        self.projectURL = projectURL
        self.loginPath = loginPath
        self.redirectURL = redirectURL
        self.callbackPath = callbackPath
        self.salt = salt
        self.middlewares = middlewares
    }
}
