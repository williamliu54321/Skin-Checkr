//
//  RootViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-07.
//

import Foundation

@MainActor // Ensures UI updates are always on the main thread.
class RootViewModel: ObservableObject {
    @Published private(set) var currentStatus: SubscriptionStatus = .notSubscribed
    
    private let listenForSubscriptionChanges: ListenForSubscriptionChangesUseCase
    private let presentPaywall: PresentPaywallUseCase
    
    init(
        listenForSubscriptionChanges: ListenForSubscriptionChangesUseCase,
        presentPaywall: PresentPaywallUseCase
    ) {
        self.listenForSubscriptionChanges = listenForSubscriptionChanges
        self.presentPaywall = presentPaywall
        
        // Start a long-running task to observe status changes for the lifetime of the ViewModel.
        Task {
            await observeSubscriptionStatus()
        }
    }
    
    private func observeSubscriptionStatus() async {
        // This loop will suspend until a new value is available, then run again.
        for await status in listenForSubscriptionChanges.execute() {
            self.currentStatus = status
        }
    }
}
    
    /// Called by the view when the user taps the button.
    func unlockButtonTapped() {
        presentPaywall.execute(for: "show_onboarding_paywall")
    }

}
