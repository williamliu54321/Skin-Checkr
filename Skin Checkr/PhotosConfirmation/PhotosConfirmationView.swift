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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("darkBlue"),
                    Color("deeperBlue")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background decorative elements
            Circle()
                .fill(Color("skyBlue").opacity(0.3))
                .frame(width: 250, height: 250)
                .blur(radius: 50)
                .offset(x: -100, y: -150)
            
            Circle()
                .fill(Color("lightBlue").opacity(0.4))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 150, y: 100)
            
            // Main content
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Separate the header text elements
                    HStack(spacing: 5) {
                        Text("Ready to")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Text("Analyze?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("skyBlue"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // Image container
                ZStack {
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250) // Use a fixed frame for consistent layout
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                // Break up the complex text into individual components
                PhotoSelectionText()
                    .padding(.top, 5)
                
                // Fixed spacer for consistent layout
                Spacer()
                    .frame(height: 20)
                
                // Analysis explanation in a glass card to match app style
                AnalysisExplanationCard()
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // Start analysis button with consistent styling
                Button(action: {
                    // Start AI Analysis
                }) {
                    HStack(spacing: 10) {
                        Text("[ ▶ ]")
                            .font(.system(size: 18, weight: .bold))
                        Text("Start AI Analysis")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .frame(width: 260)
                    .background(Color("skyBlue"))
                    .cornerRadius(30)
                    .shadow(color: Color("deeperBlue").opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.vertical, 15)
                
                // Alternative actions with proper spacing
                AlternativeActionButtons()
                    .padding(.bottom, 20)
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - Helper Views to break up complex expressions

// Photo selection text component
struct PhotoSelectionText: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("[ The photo ")
                .foregroundColor(.white)
            Text("user")
                .foregroundColor(Color("skyBlue"))
            Text(" just took ")
                .foregroundColor(.white)
            Text("or")
                .foregroundColor(Color("skyBlue"))
            Text(" selected ]")
                .foregroundColor(.white)
        }
        .font(.system(size: 16, weight: .medium))
    }
}

// Analysis explanation card component
struct AnalysisExplanationCard: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text("Our AI will ")
                    .foregroundColor(.white)
                Text("check for")
                    .foregroundColor(Color("skyBlue"))
                Text(" common risk")
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 0) {
                Text("factors ")
                    .foregroundColor(.white)
                Text("like")
                    .foregroundColor(Color("skyBlue"))
                Text(" Asymmetry, Border, & Color.")
                    .foregroundColor(.white)
            }
        }
        .font(.system(size: 16, weight: .medium))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color("skyBlue").opacity(0.2))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("lightBlue"), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// Alternative action buttons component
struct AlternativeActionButtons: View {
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                // Retake photo
            }) {
                Text("[ Retake Photo ]")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("skyBlue"))
            }
            
            Text("or")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Button(action: {
                // Choose different photo
            }) {
                Text("[ Choose Different ]")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("skyBlue"))
            }
        }
    }
}

#Preview {
    // To create a preview, we first create a dummy ViewModel.
    let dummyViewModel = PhotosConfirmationViewModel(
        image: UIImage(systemName: "photo.circle.fill")!,
        onBack: { print("Back tapped") },
        onRetake: { print("Retake tapped") },
        onStartAnalysis: { _ in print("Start analysis tapped") }
    )
    
    // Then we pass that ViewModel to the view.
    return PhotosConfirmationView(viewModel: dummyViewModel)
}

