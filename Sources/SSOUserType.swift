import AdminPanelProvider

public protocol SSOUserType {
    static func makeSSOUser(withEmail: String) throws -> Self
}

extension AdminPanelUser: SSOUserType {
    public static func makeSSOUser(withEmail email: String) throws -> AdminPanelUser {
        return try .init(
            name: "Admin",
            title: "Nodes Admin",
            email: email,
            password: String.random(16),
            role: "Super Admin",
            shouldResetPassword: false,
            avatar: nil
        )
    }
}
