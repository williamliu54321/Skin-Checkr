//
//  HomeViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-16.
//


import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    let onStartMainPaywall: () -> Void
    let onShowGetImageView: () -> Void // <-- 1. Add the new property

    // 2. Update the initializer to accept the new closure
    init(placePaywall: @escaping () -> Void, showGetImageView: @escaping () -> Void) {
        self.onStartMainPaywall = placePaywall
        self.onShowGetImageView = showGetImageView // <-- 3. Assign it
    }
}

// Add this extension for easy previewing
extension HomeViewModel {
    static var mock: HomeViewModel {
        // Create an instance where the closures do nothing, or just print a message.
        HomeViewModel(
            placePaywall: { print("Preview: Tapped place paywall.") },
            showGetImageView: { print("Preview: Tapped show get image view.") }
        )
    }
}
