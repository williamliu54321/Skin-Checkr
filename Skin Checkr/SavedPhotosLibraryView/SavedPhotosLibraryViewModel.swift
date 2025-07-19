// Create a new file: SavedPhotosLibraryViewModel.swift
import SwiftUI

@MainActor
final class SavedPhotosLibraryViewModel: ObservableObject {
    
    // MARK: - Communication Closures
    
    /// The action to perform when the user taps the top-left "Back" button.
    let onBack: () -> Void
    
    /// The action to perform after a photo is successfully selected from the picker.
    let onPhotoSelected: (UIImage) -> Void
    
    // MARK: - Initializer
    
    init(
        onBack: @escaping () -> Void,
        onPhotoSelected: @escaping (UIImage) -> Void
    ) {
        self.onBack = onBack
        self.onPhotoSelected = onPhotoSelected
    }
    
    // MARK: - Intents from the View
    
    func backButtonTapped() {
        onBack()
    }
}
