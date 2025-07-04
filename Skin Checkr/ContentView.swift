//
//  ContentView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-04.
//


// List of Best Practices I Want to Do for my App
// MVVM Architecture
// Dependency Injection,
// Protocols
// Mocks
// Data Services

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
