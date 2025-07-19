// Create a new file: AnalyzingView.swift
import SwiftUI

struct AnalyzingView: View {
    // The coordinator will provide this action to be run when the "analysis" is complete.
    let onAnalysisComplete: () -> Void
    
    // State to cycle through the "analysis" text.
    @State private var analysisStep = 0
    private let analysisSteps = [
        "Analyzing Asymmetry...",
        "Checking Border Irregularity...",
        "Assessing Color Variations...",
        "Compiling Report..."
    ]

    var body: some View {
        ZStack {
            // Your standard app background
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue"), Color("deeperBlue")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Analyzing Your Photo")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                
                // Replace with a real Lottie animation for best results!
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(3)
                
                Text(analysisSteps[analysisStep])
                    .font(.headline)
                    .foregroundColor(Color("skyBlue"))
                    .contentTransition(.interpolate) // Smoothly fades between text
            }
        }
        .onAppear {
            // Start the text cycling animation.
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
                withAnimation {
                    analysisStep = (analysisStep + 1) % analysisSteps.count
                }
            }

            // This is the main timer for the entire process.
            // After 4 seconds, it triggers the onAnalysisComplete closure.
            Task {
                try? await Task.sleep(for: .seconds(4))
                onAnalysisComplete()
            }
        }
    }
}
