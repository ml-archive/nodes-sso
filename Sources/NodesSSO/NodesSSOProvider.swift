import Leaf
import Sugar
import Vapor

public final class NodesSSOProvider<U: NodesSSOAuthenticatable>: Provider {
    private let config: NodesSSOConfig

    public init(config: NodesSSOConfig) {
        self.config = config
    }

    public func register(_ services: inout Services) throws {
        try services.register(MutableLeafTagConfigProvider())
        services.register(config)
        services.register(NodesSSOConfigTagData(loginPath: config.loginPath))
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        try routes(container.make(), config: container.make(), controller: NodesSSOController<U>())

        let tags: MutableLeafTagConfig = try container.make()
        tags.use(NodesSSOConfigTag(), as: "nodessso:config")

        return .done(on: container)
    }
}
