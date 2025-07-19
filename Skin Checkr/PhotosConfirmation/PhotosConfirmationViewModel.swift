//
//  PhotosConfirmationViewModel 2.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-19.
//


// In PhotosConfirmationViewModel.swift
import SwiftUI

@MainActor
final class PhotosConfirmationViewModel: ObservableObject {
    
    // --- ADD THIS ---
    // A @Published property to track the loading state. The View will watch this.
    @Published var isAnalyzing = false
    
    // --- (Your existing properties) ---
    let image: UIImage
    private let onBack: () -> Void
    private let onRetake: () -> Void
    
    // --- UPDATE THIS ---
    // The analysis closure now expects a final String result, not the image.
    private let onStartAnalysis: (String) -> Void
    
    // Create an instance of our new service.
    private let analysisService = AnalysisService()

    // UPDATE THE INITIALIZER to match the new closure type.
    init(
        image: UIImage,
        onBack: @escaping () -> Void,
        onRetake: @escaping () -> Void,
        onStartAnalysis: @escaping (String) -> Void // Now takes a String
    ) {
        self.image = image
        self.onBack = onBack
        self.onRetake = onRetake
        self.onStartAnalysis = onStartAnalysis
    }
    
    func backButtonTapped() { onBack() }
    func retakeButtonTapped() { onRetake() }
    
    // --- REPLACE THE OLD startAnalysisButtonTapped ---
    func startAnalysisButtonTapped() {
        // Prevent user from tapping again while it's already running.
        guard !isAnalyzing else { return }
        
        // 1. Set loading state to true. This will trigger the UI to update.
        isAnalyzing = true
        
        // 2. Start a background task for the network call.
        Task {
            do {
                // 3. Call the networking service and wait for the result.
                let analysisResult = try await analysisService.analyzeImage(image: image)
                
                // 4. On success, hand the result off to the AppCoordinator.
                onStartAnalysis(analysisResult)
                
            } catch {
                // Handle any errors (e.g., no internet, server error).
                print("❌ Analysis failed: \(error.localizedDescription)")
                // Here you could trigger an error alert for the user.
            }
            
            // 5. No matter what, set the loading state back to false.
            isAnalyzing = false
        }
    }
}

