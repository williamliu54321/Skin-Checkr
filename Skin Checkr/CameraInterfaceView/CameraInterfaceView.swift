//
//  CameraInterfaceView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-05.
//

import SwiftUI

struct CameraInterfaceView: View {
    
    /// The ViewModel is injected from a parent. It holds all the camera logic.
    @ObservedObject var viewModel: CameraInterfaceViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Layer 1: The Live Camera Feed (The Missing Part)
            // This custom view displays the live video session from the ViewModel.
            // It must be the first thing in the ZStack to be in the background.
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            // MARK: - Layer 2: Your UI Overlay
            // This is your entire UI, placed on top of the camera feed.
            uiOverlay
        }
        .onAppear {
            // When the view appears, we tell the ViewModel to start the camera session.
            // If this is missing, the camera will never turn on.
            viewModel.startCamera()
        }
        // It's good practice to set a black background in case the camera feed
        // takes a moment to start, so you don't see the blue gradient.
        .background(Color.black.ignoresSafeArea())
    }
    
    /// A computed property containing all of your UI elements for better code organization.
    private var uiOverlay: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                // ACTION 1: The "Close" button calls the onBack closure in the ViewModel.
                Button(action: viewModel.onBack) {
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
            
            // Focus crosshair - purely visual
            ZStack {
                Circle().stroke(Color("skyBlue"), lineWidth: 2).frame(width: 100, height: 100)
                Circle().stroke(Color("skyBlue"), lineWidth: 1).frame(width: 120, height: 120)
                Circle().fill(Color("skyBlue")).frame(width: 8, height: 8)
            }
            
            // Guidance text - purely visual
            VStack(spacing: 5) {
                HStack(spacing: 0) {
                    Text("Place mole ").foregroundColor(.white)
                    + Text("in").foregroundColor(Color("skyBlue"))
                    + Text(" the center ").foregroundColor(.white)
                    + Text("of").foregroundColor(Color("skyBlue"))
                    + Text(" frame").foregroundColor(.white)
                }
                .font(.system(size: 16, weight: .medium))
            }
            .padding(.vertical, 12).padding(.horizontal, 20)
            .background(Color("skyBlue").opacity(0.2))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("lightBlue"), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 40).padding(.top, 10)
            
            // Camera indicators - purely visual
            VStack(spacing: 15) {
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.fill").foregroundColor(Color("skyBlue"))
                    Text("Lighting:").foregroundColor(.white)
                    Text("GOOD").foregroundColor(Color("skyBlue")).fontWeight(.semibold)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "arrow.up.and.down").foregroundColor(Color("skyBlue"))
                    Text("Distance:").foregroundColor(.white)
                    Text("A BIT CLOSER").foregroundColor(Color("skyBlue")).fontWeight(.semibold)
                }
            }
            .font(.system(size: 16, weight: .medium))
            .padding(.vertical, 15).padding(.horizontal, 20)
            .background(Color("skyBlue").opacity(0.2))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("lightBlue"), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20).padding(.top, 10)
            
            Spacer()
            
            // ACTION 2: The Shutter button tells the ViewModel to capture a photo.
            Button(action: viewModel.capturePhoto) {
                ZStack {
                    Circle().fill(Color("skyBlue").opacity(0.3)).frame(width: 80, height: 80)
                    Circle().stroke(Color.white, lineWidth: 3).frame(width: 70, height: 70)
                    Circle().fill(Color.white).frame(width: 60, height: 60)
                }
            }
            .shadow(color: Color("skyBlue").opacity(0.5), radius: 15, x: 0, y: 0)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview Provider

#Preview {
    // This preview will show your UI on a black background.
    // To see a live camera, you must run on a physical device.
    CameraInterfaceView(viewModel: CameraInterfaceViewModel(
        onBack: {
            print("Preview: Back button tapped.")
        },
        onPhotoTaken: { _ in
            print("Preview: Photo would have been taken.")
        }
    ))
}
