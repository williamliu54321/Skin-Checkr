//
//  ResultsView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct ResultsView: View {
    
    // CORRECT: Use @ObservedObject because this view is GIVEN the ViewModel.
    @ObservedObject var viewModel: ResultsViewModel
    
    // The static sample data is no longer needed.
    
    var body: some View {
        ZStack {
            // Your background is unchanged
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue"), Color("deeperBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            Circle().fill(Color("skyBlue").opacity(0.3)).frame(width: 250, height: 250).blur(radius: 50).offset(x: -100, y: -150)
            Circle().fill(Color("lightBlue").opacity(0.4)).frame(width: 300, height: 300).blur(radius: 60).offset(x: 150, y: 100)
            
            // This parent VStack separates the scrollable content from the sticky buttons.
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        HStack {
                            // CONNECTED: The button now calls the ViewModel's method.
                            Button(action: viewModel.backButtonTapped) {
                                HStack(spacing: 5) {
                                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                                    Text("back").font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Skin Checkr").font(.system(size: 38, weight: .bold)).foregroundColor(.white)
                        
                        // DYNAMIC: Image container now uses the ViewModel's data.
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.6)).frame(height: 340)
                            if let image = viewModel.imageData {
                                Image(uiImage: image).resizable().scaledToFit()
                            } else {
                                Circle().fill(Color.black).frame(width: 40, height: 40)
                            }
                        }
                        .cornerRadius(10).padding(.horizontal, 20)
                        
                        // DYNAMIC: Results section now uses the ViewModel's data.
                        VStack(spacing: 20) {
                            Text("Risk Assessment: \(viewModel.riskLevel)").font(.system(size: 20, weight: .semibold))
                            Divider().background(Color("lightBlue").opacity(0.7)).padding(.horizontal, 20)
                            HStack {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Asymmetry:"); Text("Border:"); Text("Color:")
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(viewModel.asymmetry); Text(viewModel.border); Text(viewModel.color)
                                }
                                Spacer()
                                // TODO: Make these indicators dynamic based on the results
                                VStack(alignment: .leading, spacing: 20) {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                                }
                            }
                            .font(.system(size: 18)).padding(.horizontal, 40)
                            
                            Divider().background(Color("lightBlue").opacity(0.7)).padding(.horizontal, 20)
                            
                            Text(viewModel.aiNotes)
                                .font(.system(size: 16)).multilineTextAlignment(.center).padding(.horizontal, 20)
                            
                            Text("*Not a medical diagnosis. Consult a doctor.")
                                .font(.system(size: 12)).foregroundColor(Color("paleBlue")).padding(.top, 5)
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.bottom, 20)
                } // End of ScrollView
                
                // --- Sticky Buttons Area ---
                // We'll add the "Save" button back in here for completeness.
                HStack(spacing: 15) {
                    Button(action: viewModel.saveButtonTapped) {
                        Text("Save this Mole")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .background(Color.clear) // Secondary action style
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("lightBlue"), lineWidth: 1))
                    }
                    
                    Button(action: viewModel.doneButtonTapped) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .background(Color("skyBlue")) // Primary action style
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    // The preview now creates a dummy ViewModel and passes it to the view.
    let previewViewModel = ResultsViewModel(
        riskLevel: "Medium Risk",
        asymmetry: "Low",
        border: "Low",
        color: "Medium",
        imageData: UIImage(systemName: "photo"),
        aiNotes: "Our AI notes consistent color and smooth edges. No immediate concerns detected.",
        onBack: {},
        onDone: {},
        onSave: {}
    )
    return ResultsView(viewModel: previewViewModel)
}
