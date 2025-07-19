//
//  AnalysisResultModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-19.
//

import Foundation

// A simple struct to represent the data of a single analysis.
// - Codable: So you can easily save/load it (e.g., to UserDefaults or a file).
// - Identifiable: Useful if you ever want to show a list of saved results.
// - Equatable: Good for testing and SwiftUI list updates.
struct AnalysisResult: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date // It's important to know WHEN the analysis was done.
    
    // The data from the analysis
    let riskLevel: String
    let asymmetry: String
    let border: String
    let color: String
    let aiNotes: String
    
    // The image is stored as raw Data, not a UIImage.
    // This is a core principle: Models should not contain UI-specific types.
    let imageData: Data?
    
    // A sample for testing and previews
    static var mock: AnalysisResult {
        .init(
            id: UUID(),
            date: Date(),
            riskLevel: "Medium Risk",
            asymmetry: "Low",
            border: "Low",
            color: "Medium",
            aiNotes: "This is a mock analysis. Our AI notes consistent color and smooth edges. No immediate concerns detected.",
            imageData: nil
        )
    }
}
