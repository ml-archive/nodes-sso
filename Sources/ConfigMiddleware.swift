import Vapor

/// Middleware to expose SSO config.
internal final class ConfigMiddleware: Middleware {
    private let loginPath: String

    /// Initializes the middleware to expose SSO config.
    ///
    /// - Parameter loginPath: The login path to start the SSO flow.
    internal init(loginPath: String) {
        self.loginPath = loginPath
    }

    internal func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Response {
        var updatedConfig = request.storage["adminPanel"] as? Node ?? Node([:])
        var updatedSSOConfig = updatedConfig["sso"] ?? Node([:])

        updatedSSOConfig["nodes"] = try Node(node: ["loginPath": loginPath])
        updatedConfig["sso"] = updatedSSOConfig
        request.storage["adminPanel"] = updatedConfig
        return try next.respond(to: request)
    }
}
