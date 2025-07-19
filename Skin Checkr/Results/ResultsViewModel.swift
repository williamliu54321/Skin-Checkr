// In ResultsViewModel.swift
import SwiftUI

@MainActor
final class ResultsViewModel: ObservableObject {
    
    // MARK: - Properties for the View
    // The ViewModel still provides simple, display-ready properties for the View.
    let riskLevel: String
    let asymmetry: String
    let border: String
    let color: String
    let imageData: UIImage? // The View needs a UIImage, so the ViewModel creates it.
    let aiNotes: String

    // MARK: - Action Closures
    private let onBack: () -> Void
    private let onDone: () -> Void
    private let onSave: () -> Void

    // The ViewModel holds the raw model object.
    private let result: AnalysisResult

    // MARK: - Initializer
    // The init is now much cleaner! It just takes the model and the closures.
    init(
        result: AnalysisResult,
        onBack: @escaping () -> Void,
        onDone: @escaping () -> Void,
        onSave: @escaping () -> Void
    ) {
        self.result = result // Store the model
        
        // --- DATA TRANSFORMATION ---
        // The ViewModel's job: prepare the model's data for the View.
        self.riskLevel = result.riskLevel
        self.asymmetry = result.asymmetry
        self.border = result.border
        self.color = result.color
        self.aiNotes = result.aiNotes
        
        // Convert the `Data` from the model into a `UIImage` for the view.
        if let data = result.imageData {
            self.imageData = UIImage(data: data)
        } else {
            self.imageData = nil
        }
        
        // Store the closures for the buttons.
        self.onBack = onBack
        self.onDone = onDone
        self.onSave = onSave
    }
    
    // MARK: - Public Methods (Intents)
    // These are unchanged.
    
    func backButtonTapped() {
        onBack()
    }
    
    func doneButtonTapped() {
        onDone()
    }
    
    func saveButtonTapped() {
        // Now you can pass the entire 'result' model to your saving logic.
        print("Save button tapped. Saving result with ID: \(result.id)")
        onSave()
    }
}
