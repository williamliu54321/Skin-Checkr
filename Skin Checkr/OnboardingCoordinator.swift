import Foundation
import SwiftUI

class OnboardingCoordinator: ObservableObject {
    // Current step in the onboarding process
    @Published var currentStep = 0
    
    // Parent coordinator reference
    weak var parentCoordinator: AppCoordinator?
    
    init(parentCoordinator: AppCoordinator?) {
        self.parentCoordinator = parentCoordinator
    }
    
    // Navigation methods
    @MainActor
    func next() {
        print("next() called with currentStep: \(currentStep)")
        if currentStep >= 3 {
            print("Onboarding completed")
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
        currentStep = 3 // Last step
    }
    
    // Call this when onboarding is complete
    @MainActor
    func completeOnboarding() {
        // 1. Save completion state to UserDefaults
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // 2. Notify parent coordinator that onboarding is complete
        parentCoordinator?.onboardingCompleted()
        
        // Note: No need to clean up here - the parent coordinator
        // will set this coordinator to nil, which will deallocate it
    }
    
    // For debugging - to verify coordinator is properly deallocated
    deinit {
        print("OnboardingCoordinator deallocated")
    }
}
