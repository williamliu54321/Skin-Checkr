// In AnalyzingView.swift
import SwiftUI

struct AnalyzingView: View {
    
    // REMOVED: The onAnalysisComplete closure is no longer needed.
    
    // The state for cycling the text can remain for a nice visual effect.
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
                
                // The spinner indicates that real work is happening.
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(3)
                
                Text(analysisSteps[analysisStep])
                    .font(.headline)
                    .foregroundColor(Color("skyBlue"))
                    .id(analysisStep) // Helps SwiftUI animate the text change
                    .transition(.opacity.animation(.easeInOut))
            }
        }
        .onAppear {
            // The text cycling animation is purely for visual feedback.
            // It runs indefinitely until the view is removed from the screen.
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
                withAnimation {
                    // This just loops through the text steps.
                    analysisStep = (analysisStep + 1) % analysisSteps.count
                }
            }

            // REMOVED: The Task with the 4-second timer is gone.
            // The view no longer controls the duration of the process.
        }
    }
}
