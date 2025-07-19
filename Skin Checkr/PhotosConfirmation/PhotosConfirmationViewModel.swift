// In PhotosConfirmationViewModel.swift
import SwiftUI

@MainActor
final class PhotosConfirmationViewModel: ObservableObject {
    
    // REMOVED: @Published var isAnalyzing = false
    
    let image: UIImage
    private let onBack: () -> Void
    private let onRetake: () -> Void
    
    // THE onStartAnalysis CLOSURE NO LONGER RECEIVES A RESULT.
    // It's just a simple trigger.
    private let onStartAnalysis: (UIImage) -> Void
    
    // UPDATE THE INITIALIZER
    init(
        image: UIImage,
        onBack: @escaping () -> Void,
        onRetake: @escaping () -> Void,
        onStartAnalysis: @escaping (UIImage) -> Void // Now just takes an image
    ) {
        self.image = image
        self.onBack = onBack
        self.onRetake = onRetake
        self.onStartAnalysis = onStartAnalysis
    }
    
    func backButtonTapped() { onBack() }
    func retakeButtonTapped() { onRetake() }
    
    // THIS METHOD IS NOW MUCH SIMPLER.
    // It just calls the closure to trigger the navigation.
    func startAnalysisButtonTapped() {
        onStartAnalysis(image)
    }
}
