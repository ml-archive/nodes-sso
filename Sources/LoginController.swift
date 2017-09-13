import Vapor
import AdminPanelProvider

internal final class LoginController {
    private let environment: Environment
    private let hasher: CryptoHasher
    private let salt: String
    private let callbackPath: String
    private let redirectUrl: String

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

    internal func auth(req: Request) throws -> Response {
        // skip SSO on local environments
        if environment.isLocalEnvironment || req.uri.hostname.isLocalhost {
            guard let user = try AdminPanelUser.makeQuery().first() else {
                throw Abort(.internalServerError, reason: "No backend users exist. Try running `admin-panel:seeder`")
            }

            req.auth.authenticate(user)
            return redirect("/admin/dashboard").flash(.success, "Logged in as \(user.email)")
        }

        let resultingPath = req.uri.scheme + "://" + req.uri.hostname + callbackPath
        return redirect(redirectUrl + "?redirect_url=" + resultingPath)
    }

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

internal extension Environment {
    internal var isLocalEnvironment: Bool {
        return self == Environment.custom("local")
    }
}

internal extension String {
    internal var isLocalhost: Bool {
         return self == "0.0.0.0" || self == "127.0.0.1"
    }
}
