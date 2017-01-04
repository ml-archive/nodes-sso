import AdminPanel
import HTTP
import Vapor
import Auth
import BCrypt
import Foundation

public class NodesSSO: SSOProtocol {
    let droplet: Droplet
    let redirectUrl: String
    let nodesSSOSalt: String
    
    /// Init
    ///
    /// - Parameter droplet: Droplet
    /// - Throws: Abort.custom for missing configs
    required public init(droplet: Droplet) throws {
        self.droplet = droplet
        
        // Retrieve ssoRedirectUrl from config
        guard let redirectUrl: String = droplet.config["adminpanel", "ssoRedirectUrl"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NodesSSO missing ssoRedirectUrl")
        }
        
        // replace environment
        self.redirectUrl = redirectUrl.replacingOccurrences(of: "#environment", with: droplet.environment.description)
        
        
        // Retrieve nodesSSOSalt from config
        guard let nodesSSOSalt: String = droplet.config["adminpanel", "nodesSSOSalt"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NodesSSO missing nodesSSOSalt")
        }
        
        self.nodesSSOSalt = nodesSSOSalt
    }
    
    
    /// SSO auth start
    ///
    /// - Parameter request: Request
    /// - Returns: Response
    /// - Throws: Abort.custom
    public func auth(_ request: Request) throws -> Response {
        
        // Local env should just login as first user
        if droplet.environment.description == "local" || request.uri.host == "0.0.0.0" {
            guard let backendUser = try BackendUser.query().first() else {
                throw Abort.custom(status: .internalServerError, message: "Missing a backend user")
            }
            
            // Login first user and redirect
            try request.auth.login(Identifier(id: backendUser.id ?? 0))
            return Response(redirect: "/admin/dashboard").flash(.success, "Logged in as \(backendUser.email)")
        }
        
        return Response(redirect: redirectUrl)
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
        let generatedToken = nodesSSOSalt.replacingOccurrences(of: "#email", with: email)
        
        // Hash
        let hasher = CryptoHasher(method: .sha256, defaultKey: nil)
        
        // Check that token match
        if try hasher.make(generatedToken) != token {
            return Response(redirect: "/admin/login").flash(.error, "Token did not match")
        }
        
        var backendUser: BackendUser!
        
        // Lookup existing
        if let existingBackendUser: BackendUser = try BackendUser.query().filter("email", email).first() {
            backendUser = existingBackendUser
        }
            //Create a new
        else {
            var newBackendUser: BackendUser = try BackendUser(node: [
                "name": "Admin",
                "email": email,
                "password": BCrypt.hash(password: String.randomAlphaNumericString(8)),
                "role": "super-admin"
                ])
            
            try newBackendUser.save()
            backendUser = newBackendUser
        }
        
        
        // Login
        try request.auth.login(Identifier(id: backendUser.id ?? 0))
        
        // Redirect
        return Response(redirect: "/admin/dashboard").flash(.success, "Logged in as \(backendUser?.email)")
    }
}
