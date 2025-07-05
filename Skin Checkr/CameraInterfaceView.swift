//
//  CameraInterfaceView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct CameraInterfaceView: View {
    var body: some View {
        ZStack {
            // Background - darker gradient for camera but keeping app style
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("darkBlue").opacity(0.9),
                    Color("deeperBlue").opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background decorative elements (subtle)
            Circle()
                .fill(Color("skyBlue").opacity(0.1))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(x: -100, y: -150)
            
            Circle()
                .fill(Color("lightBlue").opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 150, y: 100)
            
            // Camera interface content
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        // Close action
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Close")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color("skyBlue").opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("lightBlue"), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Focus crosshair - styled to match app design
                ZStack {
                    Circle()
                        .stroke(Color("skyBlue"), lineWidth: 2)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .stroke(Color("skyBlue"), lineWidth: 1)
                        .frame(width: 120, height: 120)
                    
                    // Center dot
                    Circle()
                        .fill(Color("skyBlue"))
                        .frame(width: 8, height: 8)
                }
                
                // Guidance text - glass card to match app style
                VStack(spacing: 5) {
                    HStack(spacing: 0) {
                        Text("Place mole ")
                            .foregroundColor(.white)
                        Text("in")
                            .foregroundColor(Color("skyBlue"))
                        Text(" the center ")
                            .foregroundColor(.white)
                        Text("of")
                            .foregroundColor(Color("skyBlue"))
                        Text(" frame")
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 16, weight: .medium))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color("skyBlue").opacity(0.2))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("lightBlue"), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 40)
                .padding(.top, 10)
                
                // Camera indicators - glass card styling
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(Color("skyBlue"))
                        Text("Lighting:")
                            .foregroundColor(.white)
                        Text("GOOD")
                            .foregroundColor(Color("skyBlue"))
                            .fontWeight(.semibold)
                    }
                    
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.up.and.down")
                            .foregroundColor(Color("skyBlue"))
                        Text("Distance:")
                            .foregroundColor(.white)
                        Text("A BIT CLOSER")
                            .foregroundColor(Color("skyBlue"))
                            .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .background(Color("skyBlue").opacity(0.2))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("lightBlue"), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                
                // Shutter button - styled to match the app's aesthetic
                Button(action: {
                    // Take photo action
                }) {
                    ZStack {
                        Circle()
                            .fill(Color("skyBlue").opacity(0.3))
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                    }
                }
                .shadow(color: Color("skyBlue").opacity(0.5), radius: 15, x: 0, y: 0)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    CameraInterfaceView()
}
