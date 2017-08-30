import Vapor

internal final class ConfigMiddleware: Middleware {
    private let loginPath: String

    internal init(loginPath: String) {
        self.loginPath = loginPath
    }

    internal func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Response {
        guard
            var adminPanel = request.storage["adminPanel"] as? Node,
            var sso = adminPanel["sso"]?.object
        else {
            throw Abort(.badGateway)
        }

        sso["nodes"] = try Node(node: ["loginPath": loginPath])
        adminPanel["sso"] = Node(sso)
        request.storage["adminPanel"] = adminPanel
        return try next.respond(to: request)
    }
}
