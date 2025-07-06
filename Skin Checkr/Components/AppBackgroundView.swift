//
//  AppBackgroundVIew.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-06.
//


import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
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
    }
}


#Preview {
    ZStack{
        AppBackgroundView()
    }
}
