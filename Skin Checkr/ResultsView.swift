//
//  ResultsView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct ResultsView: View {
    // Sample data - you would pass this in from scan results
    let riskLevel: String = "Medium Risk"
    let asymmetry: String = "Low"
    let border: String = "Low"
    let color: String = "Medium"
    let imageData: UIImage? = nil // You would pass in the actual mole image
    
    var body: some View {
        ZStack {
            // Same background gradient as HomeView
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("darkBlue"),
                    Color("deeperBlue")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Same decorative background elements
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
            VStack(spacing: 25) {
                // Back button and title
                HStack {
                    Button(action: {
                        // Handle back navigation
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Text("Skin Checkr")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
                
                // Image container
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(height: 340)
                    
                    if let image = imageData {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        // Placeholder black spot for demo
                        Circle()
                            .fill(Color.black)
                            .frame(width: 40, height: 40)
                    }
                }
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                // Results section
                VStack(spacing: 20) {
                    // Risk assessment
                    Text("Risk Assessment: \(riskLevel)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color("lightBlue").opacity(0.7))
                        .padding(.horizontal, 20)
                    
                    // Metrics grid
                    HStack {
                        // Labels
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Asymmetry:")
                                .font(.system(size: 18))
                            Text("Border:")
                                .font(.system(size: 18))
                            Text("Color:")
                                .font(.system(size: 18))
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Values
                        VStack(alignment: .leading, spacing: 20) {
                            Text(asymmetry)
                                .font(.system(size: 18))
                            Text(border)
                                .font(.system(size: 18))
                            Text(color)
                                .font(.system(size: 18))
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Indicators
                        VStack(alignment: .leading, spacing: 20) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.yellow)
                        }
                        .font(.system(size: 18))
                    }
                    .padding(.horizontal, 40)
                    
                    Divider()
                        .background(Color("lightBlue").opacity(0.7))
                        .padding(.horizontal, 20)
                    
                    // AI notes
                    Text("Our AI notes consistent color and smooth edges. No immediate concerns detected.")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Disclaimer
                    Text("*Not a medical diagnosis. Consult a doctor.")
                        .font(.system(size: 12))
                        .foregroundColor(Color("paleBlue"))
                        .padding(.top, 5)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 15) {
                    Button(action: {
                        // Save this mole
                    }) {
                        Text("Save this Mole")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color("skyBlue").opacity(0.3))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("lightBlue"), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        // Done action
                    }) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color("skyBlue").opacity(0.3))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("lightBlue"), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}
#Preview {
    ResultsView()
}
