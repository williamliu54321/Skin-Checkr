//
//  RootView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-07.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel

    var body: some View {
        // This is the core logic you asked for, implemented cleanly.
        // The RootView switches its content based on the ViewModel's state.
        switch viewModel.currentStatus {
        case .subscribed:
            HomeView()
                .withAppBackground() // Apply the background only to the main app.
        case .notSubscribed:
            OnboardingView(viewModel: viewModel)
        }
    }
}


#Preview {
    RootView()
}
