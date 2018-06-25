import Leaf
import Sugar
import Vapor

public final class NodesSSOProvider<U: NodesSSOAuthenticatable>: Provider {
    private let config: NodesSSOConfig

    public init(config: NodesSSOConfig) {
        self.config = config
    }

    public func register(_ services: inout Services) throws {
        services.register(config)
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        try routes(container.make(), config: container.make(), controller: NodesSSOController<U>())
        return .done(on: container)
    }
}
