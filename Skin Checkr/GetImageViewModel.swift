//
//  GetImageViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-17.
//

// Create a new file: GetImageViewModel.swift

import Foundation

@MainActor
final class GetImageViewModel: ObservableObject {
    // This closure will be provided by the AppCoordinator
    let onBack: () -> Void

    init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }

    // You can add other functions here later, like for taking a photo
    // or picking from the library.
}
