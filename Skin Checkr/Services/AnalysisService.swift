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


// In AnalysisService.swift
import SwiftUI
import FirebaseFunctions

// ... (Your AnalysisResult, FirebaseFunctionResponse, and AnalysisError structs/enums go here) ...

struct AnalysisService: AnalysisServiceProtocol {
    
    private let functions = Functions.functions()
    
    func analyzeImage(image: UIImage) async throws -> AnalysisResult {
        
        // 1. Convert the UIImage to compressed JPEG data.
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AnalysisError.imageDataConversionFailed
        }
        
        // 2. Encode the image data into a Base64 string.
        let imageBase64 = imageData.base64EncodedString()
        
        // --- DEBUG PRINT 1 ---
        // Confirm that the image was successfully converted and get its size.
        print("✅ Preparing to send image. Base64 String Length: \(imageBase64.count)")
        
        // 3. Prepare the data payload to send to the function.
        let requestData = ["imageBase64": imageBase64]
        
        do {
            // 4. Call the cloud function by name.
            print("▶️ Calling Firebase Function 'analyzeImage'...")
            let result = try await functions.httpsCallable("analyzeImage").call(requestData)
            print("✅ Received response from Firebase Function.")
            
            // --- DEBUG PRINT 2 ---
            // Inspect the raw data that came back before trying to decode it.
            if let responseDict = result.data as? [String: Any] {
                print("📜 Raw server response dictionary: \(responseDict)")
            }
            
            // 5. Decode the result.
            //    First, convert the raw `result.data` (which is Any) to JSON Data.
            let jsonData = try JSONSerialization.data(withJSONObject: result.data)
            
            //    Then, decode the outer FirebaseFunctionResponse object.
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Important if your model has dates
            let decodedResponse = try decoder.decode(FirebaseFunctionResponse.self, from: jsonData)
            
            // --- DEBUG PRINT 3 ---
            // Confirm that the final model was decoded successfully.
            print("✅ Successfully decoded AnalysisResult model.")
            
            // 6. Return the nested AnalysisResult model.
            return decodedResponse.result
            
        } catch {
            // --- DEBUG PRINT 4 ---
            // If anything goes wrong, this will print the specific error.
            print("❌ Firebase Cloud Function call or decoding failed: \(error.localizedDescription)")
            
            // Pass the error up to the ViewModel to be handled.
            throw AnalysisError.functionCallFailed(error)
        }
    }
}
