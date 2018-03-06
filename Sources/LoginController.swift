import Vapor
import AdminPanelProvider

/// Takes care of controlling the SSO flow.
internal final class LoginController {
    private let environment: Environment
    private let hasher: CryptoHasher
    private let salt: String
    private let callbackPath: String
    private let redirectUrl: String

    /// Initializes the controller for handling the SSO flow.
    ///
    /// - Parameters:
    ///   - environment: Current environment.
    ///   - hasher: Hasher for generating SSO token.
    ///   - salt: Salt for the hasher
    ///   - callbackPath: Path to finish the SSO flow.
    ///   - redirectUrl: External link to SSO.
    internal init(
        environment: Environment,
        hasher: CryptoHasher,
        salt: String,
        callbackPath: String,
        redirectUrl: String
    ) {
        self.environment = environment
        self.hasher = hasher
        self.salt = salt
        self.callbackPath = callbackPath
        self.redirectUrl = redirectUrl
    }

    /// Start the SSO flow.
    ///
    /// - Parameter req: Current request.
    /// - Returns: A redirect to the external SSO url.
    /// - Throws: If no backend user has been created on local environment.
    internal func auth(req: Request) throws -> Response {
        // skip SSO on local environments
        if environment.isLocalEnvironment || req.uri.hostname.isLocalhost {
            guard let user = try AdminPanelUser.makeQuery().first() else {
                throw Abort(.internalServerError, reason: "No backend users exist. Try running `admin-panel:seeder`")
            }

            req.auth.authenticate(user)
            return redirect("/admin/dashboard").flash(.success, "Logged in as \(user.email)")
        }

        let scheme = req.peerScheme ?? req.uri.scheme

        let resultingPath = scheme + "://" + req.uri.hostname + callbackPath
        return redirect(redirectUrl + "?redirect_url=" + resultingPath)
    }

    /// Finishes the SSO flow.
    ///
    /// - Parameter req: Current request.
    /// - Returns: A redirect to the dashboard after the user has been logged in.
    /// - Throws: If hashing or saving a new user fails.
    internal func callback(req: Request) throws -> ResponseRepresentable {
        guard
            let token = req.data["token"]?.string,
            let email = req.data["email"]?.string
        else {
            return redirect("/admin/login").flash(.error, "Missing token")
        }

        let salt = self.salt.replacingOccurrences(of: "#email", with: email)
        let validToken = try hasher.make(salt).makeString()

        if token != validToken {
            return redirect("/admin/login").flash(.error, "Token did not match. Try again")
        }

        let user: AdminPanelUser
        if let existing = try AdminPanelUser.makeQuery().filter("email", email).first() {
            user = existing
        } else {
            user = try AdminPanelUser(
                name: "Admin",
                title: "Nodes Admin",
                email: email,
                password: String.random(16),
                role: "Super Admin",
                shouldResetPassword: false,
                avatar: nil
            )

            try user.save()
        }

        req.auth.authenticate(user)
        return redirect("/admin/dashboard").flash(.success, "Logged in as \(user.email)")
    }
}

fileprivate extension Environment {
    fileprivate var isLocalEnvironment: Bool {
        return self == Environment.custom("local")
    }
}

fileprivate extension String {
    fileprivate var isLocalhost: Bool {
         return self == "0.0.0.0" || self == "127.0.0.1" || self == "localhost"
    }
}
