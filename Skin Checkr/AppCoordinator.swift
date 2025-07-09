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
    private let subscriptionsRepository: SubscriptionsRepository


    init(authRepository: AuthRepository,
         subscriptionsRepository: SubscriptionsRepository) {
        self.authRepository = authRepository
        self.subscriptionsRepository = subscriptionsRepository
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
        Superwall.shared.register(placement: "StartWorkout") {
            self.currentScreen = .home // or .workout if you have that case
        }
    }
    
    func paywallPass() {
            Superwall.shared.register(placement: "StartWorkout") {
                self.currentScreen = .home
            }
        }

}
