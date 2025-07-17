//
//  GetImageView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct GetImageView: View {
    
    @ObservedObject var viewModel: GetImageViewModel
    
    @State private var savedPhotos: Int = 2
    
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
            VStack(spacing: 15) {
                // Header
                HStack {
                    Button(action: {
                        viewModel.onBack()
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
                    
                }
                .padding(.horizontal, 20)
                
                // Instructions text
                HStack {
                    Text("Choose a ")
                        .foregroundColor(.white)
                    +
                    Text("method")
                        .foregroundColor(Color("skyBlue"))
                    +
                    Text(" to add a new photo for analysis.")
                        .foregroundColor(.white)
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 20)
                
                // Camera Option
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("Take a Photo")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 15)
                .background(Color("skyBlue").opacity(0.2))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("lightBlue"), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                
                // Photos Option
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("Upload from Library")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 15)
                .background(Color("skyBlue").opacity(0.2))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("lightBlue"), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                
                Spacer()
                                
            }
        }
    }
}

#Preview {
    GetImageView(viewModel: GetImageViewModel(onBack: {}))
}
