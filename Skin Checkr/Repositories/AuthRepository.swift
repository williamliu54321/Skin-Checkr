import Foundation

// 1️⃣ Protocol defining what the repository must do
protocol AuthRepository {
    /// Attempts to log in with given credentials.
    /// Returns true if credentials are valid.
    func login(username: String, password: String) async -> Bool
}

final class MockAuthRepository: AuthRepository {
    func login(username: String, password: String) async -> Bool {
        // Simulate network call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        // Very basic dummy logic:
        return username == "will" && password == "dog"
    }
}
