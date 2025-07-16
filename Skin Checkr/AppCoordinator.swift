import Foundation
import SwiftUI
import SuperwallKit

@MainActor
final class AppCoordinator: ObservableObject {
    enum Screen {
        case onboarding
        case home
        case getImageView
    }

    @Published var currentScreen: Screen = .home

    private var onboardingCoordinator: OnboardingCoordinator?

    init() {
        Task {
            self.checkInitialFlow()
        }
    }
    
    func checkInitialFlow() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding") // This is mainly for testing purposes
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        print("checkInitialFlow hasCompletedOnboarding: \(hasCompletedOnboarding)")
        
        if !hasCompletedOnboarding {
            startOnboarding()
        } else {
            self.currentScreen = .home
        }
    }
    
    func startOnboarding() {
        
        print("startOnboarding")
        
        let coordinator = OnboardingCoordinator(
            parentCoordinator: self
        )
        
        // Store the coordinator
        self.onboardingCoordinator = coordinator
        
        // Update UI
        self.currentScreen = .onboarding
    }
    
    func onboardingCompleted() {
        // THIS IS THE MISSING PIECE!
        // Wrap the state change that causes the UI to update in an animation block.
        withAnimation(.easeInOut(duration: 0.4)) {
            // Clean up
            self.onboardingCoordinator = nil
            
            // This state change will now be animated
            self.currentScreen = .home
        }
    }

    func makeHomeView() -> some View {
        // 2. UPDATE THE VIEWMODEL INITIALIZER
        let viewModel = HomeViewModel(
            placePaywall: { [weak self] in
                self?.startMainPaywall()
            },
            // Pass the new closure that changes the screen state
            showGetImageView: { [weak self] in
                // Using withAnimation will make the transition smoother
                withAnimation {
                    self?.currentScreen = .getImageView
                }
            }
        )
        return HomeView(viewModel: viewModel)
    }

    
    func makeOnboardingView() -> some View {
        if let coordinator = onboardingCoordinator {
            return AnyView(OnboardingView(coordinator: coordinator))
        } else {
            return AnyView(ProgressView("Loading..."))
        }
    }
    
    func makeGetImageView() -> some View {
        return GetImageView()
    }

        
    func startMainPaywall() {
        Task {
            if await checkSubscriptionStatus() {
                // Subscribed
                self.currentScreen = .home
            } else {
                // Show paywall
                Superwall.shared.register(placement: "MainPaywall") {
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
    
     func checkSubscriptionStatusAndUpdateUI() {
        Task {
            if await checkSubscriptionStatus() {
                self.currentScreen = .home
            } else {
                Superwall.shared.register(placement: "MainPaywall") {
                    self.currentScreen = .home
                }
            }
        }
    }
    
    func restorePurchases() {
        Task {
            // Attempt to restore purchases
            await Superwall.shared.restorePurchases()
            
            // After restore, re-check subscription status
            if await checkSubscriptionStatus() {
                self.currentScreen = .home
            } else {
                // Still no subscription, show paywall
                Superwall.shared.register(placement: "MainPaywall") {
                    self.currentScreen = .home
                }
            }
        }
    }
}
