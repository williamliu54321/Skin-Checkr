//
//  AppBackgroundView.swift
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
        
    }
}

#Preview {
    AppBackgroundView()
}
