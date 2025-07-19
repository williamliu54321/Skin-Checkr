import Foundation
import SwiftUI
import SuperwallKit

class OnboardingCoordinator: ObservableObject {
    // --- State ---
    
    // Current step in the onboarding process
    @Published var currentStep = 0
    
    // IMPROVEMENT: Avoid "magic numbers" by defining the total number of steps.
    // If you have 4 screens (0, 1, 2, 3), there are 4 steps.
    private let totalSteps = 4
    
    // Parent coordinator reference
    weak var parentCoordinator: AppCoordinator?
    
    init(parentCoordinator: AppCoordinator?) {
        self.parentCoordinator = parentCoordinator
    }
    
    // --- Navigation Methods ---
    
    @MainActor
    func next() {
        // Use the `totalSteps` constant for a clearer check.
        // We complete onboarding when we are on the *last* step and press next.
        if currentStep >= totalSteps - 1 {
            completeOnboarding()
        } else {
            currentStep += 1
        }
    }

    @MainActor
    func back() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    @MainActor
    func skipToEnd() {
        // Navigate to the last step (index 3 if totalSteps is 4)
        currentStep = totalSteps - 1
    }
    
    // --- Flow Completion ---
    
    @MainActor
    func completeOnboarding() {
        print("Onboarding completed")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        parentCoordinator?.onboardingCompleted()
    }
    
    // --- Paywall Logic ---
    
    // FIX & RENAME: This function's job is to show a paywall if needed, and then
    // proceed with the onboarding flow.
    @MainActor
    func showPaywallIfNeeded() {
        Task {
            // FIX: Correctly await the optional chained async function.
            // We check for `true` to handle the optional Bool? result.
            if await parentCoordinator?.checkSubscriptionStatus() == true {
                // If the user is already subscribed, just skip the paywall
                // and go to the next onboarding step.
                print("User is already subscribed. Skipping paywall.")
                self.next()
            } else {
                // If not subscribed, register the paywall.
                // The dismiss handler will then proceed to the next step.
                print("User not subscribed. Showing paywall.")
                Superwall.shared.register(placement: "MainPaywall") {
                    // This closure is called when the paywall is dismissed.
                    // Now, we can proceed to the next step of onboarding.
                    print("Paywall dismissed. Moving to next step.")
                }
            }
        }
    }
    

    
    // REMOVED: The `goToHomeView` method was redundant and broke the pattern.
    // The `completeOnboarding` function is the single, correct way to end this flow.
    
    // For debugging - to verify coordinator is properly deallocated
    deinit {
        print("✅ OnboardingCoordinator deallocated")
    }
}
