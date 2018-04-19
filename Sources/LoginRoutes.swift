import Vapor
import HTTP
import AdminPanelProvider

/// Routes for handling SSO.
internal final class LoginRoutes<U: AdminPanelUserType>: RouteCollection {
    private let loginPath: String
    private let callbackPath: String
    private let controller: LoginController<U>

    /// Initializes the login routes.
    ///
    /// - Parameters:
    ///   - loginPath: Path to start the SSO flow.
    ///   - callbackPath: Path to call after user has SSO'ed.
    ///   - controller: Controller to handle login logic.
    internal init(
        loginPath: String,
        callbackPath: String,
        controller: LoginController<U>
    ) {
        self.loginPath = loginPath
        self.callbackPath = callbackPath
        self.controller = controller
    }

    internal func build(_ builder: RouteBuilder) throws {
        builder.group(middleware: Middlewares.unsecured) { unsecured in
            unsecured.get(loginPath, handler: controller.auth)
            unsecured.post(callbackPath, handler: controller.callback)
        }
    }
}
