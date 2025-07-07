//
//  Skin_CheckrApp.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-04.
//

struct Skin_CheckrApp: App {
    
    @StateObject private var viewModel: RootViewModel

    init() {
        // --- The Composition Root ---
        // We construct our entire dependency graph here, and only here.
//        let repository = SuperwallSubscriptionRepository()
//        let listenUseCase = ListenForSubscriptionChangesUseCase(repository: repository)
//        let presentUseCase = PresentPaywallUseCase(repository: repository)
            let rootViewModel = RootViewModel(
//                listenForSubscriptionChanges: listenUseCase,
//                presentPaywall: presentUseCase
            )
        // Assign the fully configured ViewModel to our @StateObject.
        _viewModel = StateObject(wrappedValue: rootViewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            // Pass the single ViewModel instance to our RootView.
            RootView(viewModel: viewModel)
        }
    }
}
