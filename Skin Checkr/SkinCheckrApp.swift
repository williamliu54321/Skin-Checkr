import SwiftUI
import SuperwallKit

@main
struct SkinCheckrApp: App {
    // Initialize coordinator directly with fresh repository instances
    @StateObject private var coordinator = AppCoordinator(
        authRepository: MockAuthRepository()
    )
    
    init() {
        Superwall.configure(apiKey: "pk_488bceb39a20344eaf219986942f0f53521c41f190b80043")
    }
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
        }
    }
}
