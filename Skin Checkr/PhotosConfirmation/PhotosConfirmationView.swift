//
//  PhotosConfirmationView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

// MARK: - Photos Confirmation Screen
struct PhotosConfirmationView: View {
    
    @ObservedObject var viewModel: PhotosConfirmationViewModel
    
    var body: some View {
        // We wrap the entire UI in a top-level ZStack. This allows us to
        // easily place the loading overlay on top of all other content.
        ZStack {
            
            // This is your main UI content.
            mainContentView
                // This modifier disables all buttons within the view when
                // the ViewModel's `isAnalyzing` property is true.
                .disabled(viewModel.isAnalyzing)
            
            // This loading overlay will only appear when the analysis is in progress.
            if viewModel.isAnalyzing {
                loadingOverlay
            }
        }
    }
    
    // Extracted your main UI into a computed property for better organization.
    private var mainContentView: some View {
        ZStack {
            // Background gradient (unchanged)
            LinearGradient(
                gradient: Gradient(colors: [Color("darkBlue"), Color("deeperBlue")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background decorative elements (unchanged)
            Circle().fill(Color("skyBlue").opacity(0.3)).frame(width: 250, height: 250).blur(radius: 50).offset(x: -100, y: -150)
            Circle().fill(Color("lightBlue").opacity(0.4)).frame(width: 300, height: 300).blur(radius: 60).offset(x: 150, y: 100)
            
            // Main content VStack
            VStack(spacing: 20) {
                // Header
                HStack {
                    // CONNECTED: The "Back" button now calls the ViewModel's method.
                    Button(action: viewModel.backButtonTapped) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                            Text("Back").font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Text("Ready to").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                        Text("Analyze?").font(.system(size: 16, weight: .semibold)).foregroundColor(Color("skyBlue"))
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 10)
                
                // DYNAMIC IMAGE: This now correctly displays the image from the ViewModel.
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                // The placeholder text component is no longer needed and has been removed.
                
                Spacer().frame(height: 20)
                
                // Analysis explanation card (unchanged)
                AnalysisExplanationCard()
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // CONNECTED: The "Start Analysis" button now calls the ViewModel's method.
                Button(action: viewModel.startAnalysisButtonTapped) {
                    HStack(spacing: 10) {
                        Text("[ ▶ ]").font(.system(size: 18, weight: .bold))
                        Text("Start AI Analysis").font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(height: 60).frame(width: 260)
                    .background(Color("skyBlue"))
                    .cornerRadius(30)
                    .shadow(color: Color("deeperBlue").opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.vertical, 15)
                
                // CONNECTED: The actions are passed down to this helper view.
                AlternativeActionButtons(
                    onRetake: viewModel.retakeButtonTapped,
                    onChooseDifferent: viewModel.backButtonTapped
                )
                .padding(.bottom, 20)
            }
            .padding(.top, 10)
        }
    }
    
    // The view for the loading overlay.
    private var loadingOverlay: some View {
        ZStack {
            // A semi-transparent black background to dim the UI.
            Color.black.opacity(0.6).ignoresSafeArea()
            
            // A spinner and some text.
            VStack {
                ProgressView() // The spinner
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2) // Make it larger
                
                Text("Analyzing...")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.top, 20)
            }
        }
    }
}

// MARK: - Helper Views

// This component remains unchanged, as it's purely informational.
struct AnalysisExplanationCard: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text("Our AI will ").foregroundColor(.white)
                + Text("check for").foregroundColor(Color("skyBlue"))
                + Text(" common risk").foregroundColor(.white)
            }
            HStack(spacing: 0) {
                Text("factors ").foregroundColor(.white)
                + Text("like").foregroundColor(Color("skyBlue"))
                + Text(" Asymmetry, Border, & Color.").foregroundColor(.white)
            }
        }
        .font(.system(size: 16, weight: .medium))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20).padding(.vertical, 15)
        .background(Color("skyBlue").opacity(0.2))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("lightBlue"), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// UPDATED: This component now accepts closures to make its buttons functional.
struct AlternativeActionButtons: View {
    let onRetake: () -> Void
    let onChooseDifferent: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: onRetake) {
                Text("[ Retake Photo ]")
            }
            
            Text("or")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Button(action: onChooseDifferent) {
                Text("[ Choose Different ]")
            }
        }
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(Color("skyBlue"))
    }
}

// MARK: - Previews
#Preview("Default State") {
    let dummyViewModel = PhotosConfirmationViewModel(
        image: UIImage(systemName: "photo.circle.fill")!,
        onBack: {}, onRetake: {}, onStartAnalysis: { _ in }
    )
    return PhotosConfirmationView(viewModel: dummyViewModel)
}

#Preview("Analyzing State") {
    let dummyViewModel = PhotosConfirmationViewModel(
        image: UIImage(systemName: "photo.circle.fill")!,
        onBack: {}, onRetake: {}, onStartAnalysis: { _ in }
    )
    dummyViewModel.isAnalyzing = true // Set the analyzing state for the preview.
    return PhotosConfirmationView(viewModel: dummyViewModel)
}
