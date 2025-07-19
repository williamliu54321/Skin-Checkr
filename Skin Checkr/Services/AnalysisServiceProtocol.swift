//  Created by William Liu on 2025-07-19.
//

import SwiftUI


// This is the "contract" that both the real and mock services must follow.
protocol AnalysisServiceProtocol {
    func analyzeImage(image: UIImage) async throws -> AnalysisResult
}

// This is the mock implementation of the contract.
struct MockAnalysisService: AnalysisServiceProtocol {
    
    // This property lets you control whether the mock should succeed or fail.
    var shouldSucceed: Bool = true
    
    // THE FIX: The return type is now correctly set to `AnalysisResult`.
    func analyzeImage(image: UIImage) async throws -> AnalysisResult {
        
        // Simulate a short 2-second network delay to make the UI feel real.
        try? await Task.sleep(for: .seconds(2))
        
        if shouldSucceed {
            // THE FIX: On success, return a complete, valid AnalysisResult model object.
            // We can use the handy `.mock` static property on your model.
            return AnalysisResult.mock
        } else {
            // THE FIX: On failure, use the `throw` keyword to send a real Error object.
            // This correctly simulates a network or server failure.
            throw AnalysisError.imageDataConversionFailed
        }
    }
}
