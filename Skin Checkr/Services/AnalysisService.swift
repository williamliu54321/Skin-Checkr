import SwiftUI
import FirebaseFunctions

// This is the struct for the OUTER part of the response from your Firebase function.
// It tells the decoder to look for a key named "result" which contains the model.
struct FirebaseFunctionResponse: Codable {
    let result: AnalysisResult
}

// Custom errors for better debugging.
enum AnalysisError: Error, LocalizedError {
    case imageDataConversionFailed
    case functionCallFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .imageDataConversionFailed:
            return "Could not convert image to data."
        case .functionCallFailed(let error):
            return "The analysis request failed: \(error.localizedDescription)"
        }
    }
}


// The "live" service that talks to Firebase.
struct AnalysisService: AnalysisServiceProtocol {
    
    private let functions = Functions.functions()
    
    // The return type is now your `AnalysisResult` model.
    func analyzeImage(image: UIImage) async throws -> AnalysisResult {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AnalysisError.imageDataConversionFailed
        }
        
        let imageBase64 = imageData.base64EncodedString()
        let requestData = ["imageBase64": imageBase64]
        
        do {
            // Call the cloud function by name.
            let result = try await functions.httpsCallable("analyzeImage").call(requestData)
            
            // Decode the new, more complex response.
            // 1. Convert the raw `result.data` to JSON Data.
            let jsonData = try JSONSerialization.data(withJSONObject: result.data)
            
            // 2. Use a custom JSONDecoder if your model uses different date formats.
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Standard for dates
            
            // 3. Decode the outer FirebaseFunctionResponse object.
            let decodedResponse = try decoder.decode(FirebaseFunctionResponse.self, from: jsonData)
            
            // 4. Return the nested AnalysisResult model.
            return decodedResponse.result
            
        } catch {
            print("❌ Firebase Cloud Function call or decoding failed: \(error)")
            throw AnalysisError.functionCallFailed(error)
        }
    }
}
