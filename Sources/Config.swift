import Vapor

internal struct Config {
    internal let environment: Environment
    internal let loginPath: String
    internal let redirectUrl: String
    internal let salt: String
    internal let callbackPath: String

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
