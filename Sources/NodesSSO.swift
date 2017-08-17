import AdminPanel
import HTTP
import Vapor
import Authentication
import BCrypt
import Random
import Foundation
import Sugar

public class NodesSSO: SSOProtocol {
    let environment: Environment
    let redirectUrl: String
    let nodesSSOSalt: String
    let ssoCallbackPath: String

    /// Init
    ///
    /// - Parameter droplet: Droplet
    /// - Throws: Abort.custom for missing configs
    required public init(droplet: Droplet) throws {
        let config = try NodesSSO.extractConfiguration(config: droplet.config)
        self.environment = config.environment
        self.redirectUrl = config.redirectUrl
        self.nodesSSOSalt = config.nodesSSOSalt
        self.ssoCallbackPath = config.ssoCallbackPath
    }

    public init(config: Config) throws {
        let config = try NodesSSO.extractConfiguration(config: config)
        self.environment = config.environment
        self.redirectUrl = config.redirectUrl
        self.nodesSSOSalt = config.nodesSSOSalt
        self.ssoCallbackPath = config.ssoCallbackPath
    }

    private static func extractConfiguration(
        config: Config
    ) throws -> (
        environment: Environment,
        redirectUrl: String,
        nodesSSOSalt: String,
        ssoCallbackPath: String
    ) {
        // Retrieve ssoRedirectUrl from config
        guard let redirectUrl: String = config["adminpanel", "ssoRedirectUrl"]?.string else {
            throw Abort(.internalServerError, reason: "NodesSSO missing ssoRedirectUrl")
        }

        // replace environment
        let redirect = redirectUrl.replacingOccurrences(of: "#environment", with: config.environment.description)


        // Retrieve nodesSSOSalt from config
        guard let nodesSSOSalt: String = config["adminpanel", "nodesSSOSalt"]?.string else {
            throw Abort(.internalServerError, reason: "NodesSSO missing nodesSSOSalt")
        }

        let salt = nodesSSOSalt

        // Retrieve ssoCallbackPath from config
        guard let ssoCallbackPath: String = config["adminpanel", "ssoCallbackPath"]?.string else {
            throw Abort(.internalServerError, reason: "NodesSSO missing ssoCallbackPath")
        }

        let callback = ssoCallbackPath
        let env = config.environment

        return (env, redirect, salt, callback)
    }
    
    
    /// SSO auth start
    ///
    /// - Parameter request: Request
    /// - Returns: Response
    /// - Throws: Abort.custom
    public func auth(_ request: Request) throws -> Response {
        
        // Local env should just login as first user
        if environment.description == "local" || request.uri.hostname == "0.0.0.0" {
            guard let backendUser = try BackendUser.makeQuery().first() else {
                throw Abort(.internalServerError, reason: "Missing a backend user")
            }
            
            // Login first user and redirect

            try request.auth.authenticate(backendUser.self, persist: false)
            return Response(redirect: "/admin/dashboard").flash(.success, "Logged in as \(backendUser.email)")
        }
 
        return Response(redirect: redirectUrl + "?redirect_url=" + (request.uri.scheme + "://" + request.uri.hostname + ssoCallbackPath))
    }
    
    
    /// SSO auth callback
    ///
    /// - Parameter request: Requst
    /// - Returns: Request
    /// - Throws: Abort.custom
    public func callback(_ request: Request) throws -> Response {
        // Guard token & email
        guard let token = request.data["token"]?.string,
            let email = request.data["email"]?.string else {
                return Response(redirect: "/admin/login").flash(.error, "Missing params")
        }
        
        // Replace email
        var generatedToken = nodesSSOSalt.replacingOccurrences(of: "#email", with: email)
        
        // Hash
        let hasher = CryptoHasher(hash: .sha256, encoding: .base64)
        generatedToken = try hasher.make(generatedToken).makeString()
        
        // Check that token match
        if generatedToken != token {
            return Response(redirect: "/admin/login").flash(.error, "Token did not match, try again")
        }
        
        var backendUser: BackendUser!
        
        // Lookup existing
        if let existingBackendUser: BackendUser = try BackendUser.makeQuery().filter("email", email).first() {
            backendUser = existingBackendUser
        }
            //Create a new
        else {
            let newBackendUser: BackendUser = try BackendUser(node: [
                "name": "Admin",
                "email": email.makeNode(in: nil),
                "password": try BCrypt.Hash.make(message: String.randomAlphaNumericString(16)).makeString(),
                "role": "super-admin",
                "created_at": Date().toDateTimeString(),
                "updated_at": Date().toDateTimeString(),
            ])
            
            try newBackendUser.save()
            backendUser = newBackendUser
        }
        
        
        // Login
        try request.auth.authenticate(backendUser.self, persist: false)
        
        // Redirect
        return Response(redirect: "/admin/dashboard").flash(.success, "Logged in as \(backendUser!.email)")
    }
}
