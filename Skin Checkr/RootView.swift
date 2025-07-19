//
//  RootView.swift
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
            // Your background gradients and circles are perfect.
            LinearGradient(
                gradient: Gradient(colors: [Color("darkBlue"), Color("deeperBlue")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            Circle().fill(Color("skyBlue").opacity(0.3)).frame(width: 250, height: 250).blur(radius: 50).offset(x: -100, y: -150)
            Circle().fill(Color("lightBlue").opacity(0.4)).frame(width: 300, height: 300).blur(radius: 60).offset(x: 150, y: 100)
            
            // The main switch that controls which view is shown.
            switch coordinator.currentScreen {
                
            case .onboarding:
                coordinator.makeOnboardingView()
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))
                
            case .home:
                coordinator.makeHomeView()
                    .transition(.opacity.animation(.easeInOut))
                
            // THE FIX #1: Correctly group all the views that belong to the "image analysis" flow.
            // We've added .resultsView to this group and removed the unused .savedPhotosLibraryView.
            case .getImageView, .cameraInterfaceView, .photosConfirmationView, .resultsView:
                
                // This transition is defined once and used by all views in this group.
                let pushTransition = AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ).animation(.easeInOut(duration: 0.4))
                
                // This nested switch determines WHICH view from the group is currently visible.
                switch coordinator.currentScreen {
                case .getImageView:
                    coordinator.makeGetImageView()
                        .transition(pushTransition)
                case .cameraInterfaceView:
                    coordinator.makeCameraInterfaceView()
                        .transition(pushTransition)
                case .photosConfirmationView:
                    coordinator.makePhotosConfirmationView()
                        .transition(pushTransition)
                case .resultsView:
                    coordinator.makeResultsView()
                        .transition(pushTransition)
                default:
                    // This is a safety net required by the compiler. It should never be reached.
                    EmptyView()
                }
                
            // This is a default case for the outer switch, in case you add more screen types later.
            // For example, if you forgot to add a screen to the group above.
            default:
                Text("Unhandled Screen State")
            }
        }
        // THE FIX #2: The global animation modifier is now attached to the ZStack.
        // This ensures that ANY change to `coordinator.currentScreen` will trigger a smooth
        // animated transition between the old view and the new view.
        .animation(.easeInOut, value: coordinator.currentScreen)
    }
}
