//
//  PhotosConfirmationViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-19.
//

// Create a new file: PhotosConfirmationViewModel.swift
import SwiftUI

@MainActor
final class PhotosConfirmationViewModel: ObservableObject {
    
    // MARK: - Properties
    
    // The data for the view to display.
    let image: UIImage
    
    // The closures to communicate actions back to the coordinator.
    private let onBack: () -> Void
    private let onRetake: () -> Void
    private let onStartAnalysis: (UIImage) -> Void
    
    // MARK: - Initializer
    
    init(
        image: UIImage,
        onBack: @escaping () -> Void,
        onRetake: @escaping () -> Void,
        onStartAnalysis: @escaping (UIImage) -> Void
    ) {
        self.image = image
        self.onBack = onBack
        self.onRetake = onRetake
        self.onStartAnalysis = onStartAnalysis
    }
    
    
    func backButtonTapped() {
        onBack()
    }
    
    func retakeButtonTapped() {
        onRetake()
    }
    
    func startAnalysisButtonTapped() {
        onStartAnalysis(image)
    }
}
