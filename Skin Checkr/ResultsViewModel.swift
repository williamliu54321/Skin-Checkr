// Create a new file: ResultsViewModel.swift
import SwiftUI

@MainActor
final class ResultsViewModel: ObservableObject {
    
    // MARK: - Data Properties
    // The coordinator will provide this data.
    let riskLevel: String
    let asymmetry: String
    let border: String
    let color: String
    let imageData: UIImage?
    let aiNotes: String

    // MARK: - Action Closures
    // These are the communication channels back to the AppCoordinator.
    private let onBack: () -> Void
    private let onDone: () -> Void
    private let onSave: () -> Void // For the "Save this Mole" button

    // MARK: - Initializer
    init(
        riskLevel: String,
        asymmetry: String,
        border: String,
        color: String,
        imageData: UIImage?,
        aiNotes: String,
        onBack: @escaping () -> Void,
        onDone: @escaping () -> Void,
        onSave: @escaping () -> Void
    ) {
        self.riskLevel = riskLevel
        self.asymmetry = asymmetry
        self.border = border
        self.color = color
        self.imageData = imageData
        self.aiNotes = aiNotes
        self.onBack = onBack
        self.onDone = onDone
        self.onSave = onSave
    }
    
    // MARK: - Public Methods (Intents)
    // The View will call these methods when buttons are tapped.
    
    func backButtonTapped() {
        onBack()
    }
    
    func doneButtonTapped() {
        onDone()
    }
    
    func saveButtonTapped() {
        print("Save button tapped. Logic to save mole data would go here.")
        onSave()
    }
}
