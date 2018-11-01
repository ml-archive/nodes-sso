import Async
import Leaf
import TemplateKit

public final class NodesSSOConfigTag: TagRenderer {
    public func render(tag: TagContext) throws -> Future<TemplateData> {
        try tag.requireParameterCount(1)
        let config = try tag.container.make(NodesSSOConfigTagData.self)
        return Future.map(on: tag) { try config.viewData(for: tag.parameters[0], tag: tag) }
    }

    public init() {}
}

public final class NodesSSOConfigTagData: Service {
    enum Keys: String {
        case loginPath
    }

    public let loginPath: String

    init(loginPath: String) {
        self.loginPath = loginPath
    }

    func viewData(for data: TemplateData, tag: TagContext) throws -> TemplateData {
        guard let key = data.string else {
            throw tag.error(reason: "Wrong type given (expected a string): \(type(of: data))")
        }

        guard let parsedKey = Keys(rawValue: key) else {
            throw tag.error(reason: "Wrong argument given: \(key)")
        }

        switch parsedKey {
        case .loginPath:
            return .string(loginPath)
        }
    }
}
