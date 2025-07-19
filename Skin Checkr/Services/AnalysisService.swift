import SwiftUI

struct AnalysisResponse: Codable {
    let result: String
}

enum AnalysisError: Error {
    case invalidURL
    case imageDataConversionFailed
    case networkRequestFailed(Error)
    case invalidServerResponse
    case decodingFailed
}

struct AnalysisService: AnalysisServiceProtocol {
    
    func analyzeImage(image: UIImage) async throws -> String {
        
        guard let url = URL(string: "https://YOUR-REGION-YOUR-PROJECT-ID.cloudfunctions.net/YOUR-FUNCTION-NAME") else {
            throw AnalysisError.invalidURL
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AnalysisError.imageDataConversionFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"analysis.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for a successful server response (HTTP 200 OK).
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw AnalysisError.invalidServerResponse
            }
            
            // 6. Decode the JSON response from the cloud function.
            let analysisResponse = try JSONDecoder().decode(AnalysisResponse.self, from: data)
            return analysisResponse.result
            
        } catch {
            // Rethrow any network or decoding errors for the ViewModel to handle.
            print("❌ Network request failed: \(error)")
            throw error
        }
    }
}
