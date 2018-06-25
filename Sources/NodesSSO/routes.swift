import Vapor

internal extension NodesSSOProvider {
    internal func routes(
        _ router: Router,
        config: NodesSSOConfig,
        controller: NodesSSOController<U>
    ) {
        router.get(config.loginPath, use: controller.auth)
        router.post(config.callbackPath, use: controller.callback)
    }
}
