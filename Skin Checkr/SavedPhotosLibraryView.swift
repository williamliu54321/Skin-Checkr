//
//  SavedPhotosLibraryView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct SavedPhotosLibraryView: View {
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
                    
                    Text("Saved Photos")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("(Not Analyzed)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("skyBlue"))
                }
                .padding(.horizontal, 20)
                
                // Selection header
                HStack {
                    Button(action: {
                        // Select action
                    }) {
                        Text("Select")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("skyBlue"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Add new action
                    }) {
                        HStack {
                            Text("Add New")
                                .font(.system(size: 16, weight: .semibold))
                            Text("+")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(Color("skyBlue"))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                
                // Photo grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    // First row
                    ForEach(0..<3) { index in
                        VStack(spacing: 5) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.6))
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(10)
                                
                                Text("[Photo]")
                                    .foregroundColor(.white)
                            }
                            
                            Text("Oct \(26 - index * 2)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text(index == 2 ? "7:15pm" : "10:20am")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Second row
                    ForEach(0..<2) { index in
                        VStack(spacing: 5) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.6))
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(10)
                                
                                Text("[Photo]")
                                    .foregroundColor(.white)
                            }
                            
                            Text(index == 0 ? "Oct 22" : "...etc")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text(index == 0 ? "9:00am" : "")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Selection instructions
                HStack {
                    Text("Select a photo to ")
                        .foregroundColor(.white)
                    +
                    Text("start")
                        .foregroundColor(Color("skyBlue"))
                    +
                    Text(" analysis")
                        .foregroundColor(.white)
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.bottom, 20)
            }
        }
    }
}
#Preview {
    SavedPhotosLibraryView()
}
