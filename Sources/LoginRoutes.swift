import Vapor
import HTTP
import AdminPanelProvider

internal final class LoginRoutes: RouteCollection {
    private let loginPath: String
    private let callbackPath: String
    private let controller: LoginController

    public init(
        loginPath: String,
        callbackPath: String,
        controller: LoginController
    ) {
        self.loginPath = loginPath
        self.callbackPath = callbackPath
        self.controller = controller
    }

    public func build(_ builder: RouteBuilder) throws {
        builder.group(middleware: Middlewares.unsecured) { unsecured in
            unsecured.get(loginPath, handler: controller.auth)
            unsecured.post(callbackPath, handler: controller.callback)
        }
    }
}
