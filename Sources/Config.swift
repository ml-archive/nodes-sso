import Vapor

/// SSO configurations.
internal struct Config {
    /// The current environment.
    internal let environment: Environment
    /// The path to start the SSO flow.
    internal let loginPath: String
    /// External link for SSO.
    internal let redirectUrl: String
    /// Salt for the hasher.
    internal let salt: String
    /// The path to finish the SSO flow.
    internal let callbackPath: String

    /// Initializes the SSO config.
    ///
    /// - Parameters:
    ///   - environment: Current environment.
    ///   - loginPath: Path to start the SSO flow.
    ///   - redirectUrl: External link to SSO.
    ///   - salt: Salt for the hasher.
    ///   - callbackPath: Path to finish the SSO flow.
    internal init(
        environment: Environment,
        loginPath: String,
        redirectUrl: String,
        salt: String,
        callbackPath: String
    ) {
        self.environment = environment
        self.loginPath = loginPath
        self.redirectUrl = redirectUrl
        self.salt = salt
        self.callbackPath = callbackPath
    }

    /// Initializes the SSO config using a Vapor config.
    ///
    /// - Parameter config: Vapor config to retrieve values from.
    /// - Throws: If required values are not present.
    internal init(_ config: Vapor.Config) throws {
        let environment = config.environment

        let configFile = "adminpanel-sso-nodes"

        guard let config = config[configFile] else {
            throw ConfigError.missingFile(configFile)
        }

        guard let redirectUrl = config["redirectUrl"]?.string else {
            throw ConfigError.missing(key: ["redirectUrl"], file: configFile, desiredType: String.self)
        }

        guard let salt = config["salt"]?.string else {
            throw ConfigError.missing(key: ["salt"], file: configFile, desiredType: String.self)
        }

        let callbackPath = config["callbackPath"]?.string ?? "/admin/sso/callback"
        let loginPath = config["loginPath"]?.string ?? "/admin/sso/login"

        self.init(
            environment: environment,
            loginPath: loginPath,
            redirectUrl: redirectUrl,
            salt: salt,
            callbackPath: callbackPath
        )
    }
}
