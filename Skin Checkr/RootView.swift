//
//  RootView 2.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//

import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        switch coordinator.currentScreen {
        case .onboarding:
            coordinator.makeOnboardingView()
                .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))

        case .home:
            coordinator.makeHomeView()
                .transition(.move(edge: .trailing))
            
        case .getImageView:
            coordinator.makeGetImageView()

        }
    }
}
