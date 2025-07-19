//
//  ResultsView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct ResultsView: View {
    
    @ObservedObject var viewModel: ResultsViewModel
    
    var body: some View {
        ZStack {
            // Your background is unchanged
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue"), Color("deeperBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            Circle().fill(Color("skyBlue").opacity(0.3)).frame(width: 250, height: 250).blur(radius: 50).offset(x: -100, y: -150)
            Circle().fill(Color("lightBlue").opacity(0.4)).frame(width: 300, height: 300).blur(radius: 60).offset(x: 150, y: 100)
            
            // This parent VStack separates the scrollable content from the sticky button.
            VStack(spacing: 0) {
                
                // --- Scrollable Content Area ---
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // --- Header ---
                        HStack {
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
                        
                        // --- Title ---
                        Text("Skin Checkr").font(.system(size: 38, weight: .bold)).foregroundColor(.white)
                        
                        // --- Image Container ---
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.6)).frame(height: 340)
                            if let image = viewModel.imageData {
                                Image(uiImage: image).resizable().scaledToFit()
                            } else {
                                Circle().fill(Color.black).frame(width: 40, height: 40)
                            }
                        }
                        .cornerRadius(10).padding(.horizontal, 20)
                        
                        // --- Results Section ---
                        VStack(spacing: 20) {
                            Text("*Not a medical diagnosis. Consult a doctor.")
                                .font(.system(size: 12)).foregroundColor(Color("paleBlue")).padding(.top, 5)

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
                            
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.bottom, 20)
                } // End of ScrollView
                
                // --- Sticky Button Area ---
                HStack {
                    // Spacer pushes the button to the right.
                    Spacer()
                    
                    Button(action: viewModel.doneButtonTapped) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 50)
                            // THE FIX: Restored your preferred transparent background style.
                            .background(Color("skyBlue").opacity(0.3))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("lightBlue"), lineWidth: 1))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    // 1. Create a mock instance of your AnalysisResult model.
    //    We can use the handy `static var mock` we created on the model itself.
    let mockResult = AnalysisResult.mock
    
    // 2. Create the ViewModel using the new, simpler initializer.
    //    We just pass the single mockResult model object and empty closures.
    let previewViewModel = ResultsViewModel(
        result: mockResult,
        onBack: { print("Preview: Back Tapped") },
        onDone: { print("Preview: Done Tapped") },
        onSave: { print("Preview: Save Tapped") }
    )
    
    // 3. Create the view and pass it the ViewModel.
    return ResultsView(viewModel: previewViewModel)
}
