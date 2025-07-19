//
//  AnalysisServiceProtocol.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-19.
//

import SwiftUI
// You can add this to the top of your AnalysisService.swift file
protocol AnalysisServiceProtocol {
    func analyzeImage(image: UIImage) async throws -> String
}
struct MockAnalysisService: AnalysisServiceProtocol {
    
    // This property lets you control whether the mock should succeed or fail.
    var shouldSucceed: Bool = true
    
    func analyzeImage(image: UIImage) async throws -> String {
        // Simulate a short network delay to make the UI feel real.
        try? await Task.sleep(for: .seconds(2))
        
        if shouldSucceed {
            // Return a realistic-looking fake success message.
            return "This is a mock analysis result. The mole shows low asymmetry, a regular border, and consistent color. This is not a medical diagnosis."
        } else {
            // Return a fake error.
            throw AnalysisError.invalidServerResponse
        }
    }
}
