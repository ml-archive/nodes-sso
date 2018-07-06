import Vapor

internal extension NodesSSOProvider {
    internal func routes(
        _ router: Router,
        config: NodesSSOConfig,
        controller: NodesSSOController<U>
    ) {
        router.group(config.middlewares) { group in
            group.get(config.loginPath, use: controller.auth)
            group.post(config.callbackPath, use: controller.callback)
        }
    }
}
