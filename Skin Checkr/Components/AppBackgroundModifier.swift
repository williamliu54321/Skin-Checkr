//
//  AppBackgroundVIew.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-06.
//


import SwiftUI

// 1. The ViewModifier with the background logic directly inside it.
struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            // The background views are placed directly here.
            // No need to call a separate AppBackgroundView().
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("darkBlue"),
                    Color("deeperBlue")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea() // Use ignoresSafeArea() in modern SwiftUI
            
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
            
            // The original content of the view is placed on top.
            content
        }
    }
}

// 2. The convenience extension to make it easy to use.
extension View {
    func withAppBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}

#Preview("App Background") {
    // Create a sample view to apply our modifier to.
    // A Text view is perfect for demonstration.
    Text("Sample Content")
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(.white) // Make the text white to see it against the dark background
        .withAppBackground()      // Apply the modifier here to preview its effect.
}

