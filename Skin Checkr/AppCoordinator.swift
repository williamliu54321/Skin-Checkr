import Foundation
import SwiftUI
import SuperwallKit

@MainActor
final class AppCoordinator: ObservableObject {
    enum Screen {
        case login
        case home
    }

    @Published var currentScreen: Screen = .login

    // Dependencies
    private let authRepository: AuthRepository


    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // Factory method for LoginView
    func makeLoginView() -> some View {
        let viewModel = LoginViewModel(
            authRepository: authRepository,
            onLoginSuccess: {
                self.currentScreen = .home
            }
        )
        return LoginView(viewModel: viewModel)
    }

    func makeHomeView() -> some View {
        let viewModel = HomeViewModel(
            authRepository: authRepository,
            onStartWorkout: { [weak self] in
                self?.startWorkout()
            }
        )
        return HomeView(viewModel: viewModel)
    }
    
    func startWorkout() {
        Task {
            if await checkSubscriptionStatus() {
                // Subscribed
                self.currentScreen = .home
            } else {
                // Show paywall
                Superwall.shared.register(placement: "StartWorkout") {
                    self.currentScreen = .home
                }
            }
        }
    }

    func checkSubscriptionStatus() async -> Bool {
        let status = await Superwall.shared.subscriptionStatus
        if case .active = status {
            return true
        } else {
            return false
        }
    }
}
