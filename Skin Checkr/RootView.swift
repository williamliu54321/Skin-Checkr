//
//  RootView 2.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//

import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
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
            
            switch coordinator.currentScreen {
            case .onboarding:
                coordinator.makeOnboardingView()
                    // This is perfect. The onboarding view slides away to the left,
                    // revealing the home screen which was already there (.identity).
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))

            case .home:
                coordinator.makeHomeView()
                    // The home screen should fade in and out. It's the "base" layer.
                    // It doesn't slide, the other views slide on TOP of it.
                    .transition(.opacity.animation(.easeInOut))
                
            case .getImageView, .cameraInterfaceView, .savedPhotosLibraryView, .photosConfirmationView:
                // GROUPING all hierarchical views together.
                // This is the key to fixing the overlay issue.
                // Every view in this flow uses the same "push" animation rule.
                
                // When you go from GetImage -> Camera, the GetImage view slides to the left.
                // When you go from Camera -> GetImage (back), the Camera view slides to the right.
                let pushTransition = AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ).animation(.easeInOut(duration: 0.4))

                // The switch determines WHICH view is shown,
                // but the transition is the same for all of them.
                switch coordinator.currentScreen {
                case .getImageView:
                    coordinator.makeGetImageView()
                        .transition(pushTransition)
                case .cameraInterfaceView:
                    coordinator.makeCameraInterfaceView()
                        .transition(pushTransition)
                case .savedPhotosLibraryView:
                    coordinator.makeSavedPhotosLibraryView()
                        .transition(pushTransition)
                case .photosConfirmationView:
                    coordinator.makePhotosConfirmationView()
                        .transition(pushTransition)
                default:
                    EmptyView() // Should not happen, but required for switch
                }
            }
        }
        // Applying a global animation makes all state changes smooth
        .animation(.easeInOut, value: coordinator.currentScreen)
    }

}
