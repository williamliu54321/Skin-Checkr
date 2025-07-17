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
//Data Services
import SwiftUI

struct ScanReminder: Identifiable {
    var id = UUID()
    var location: String
    var dueDate: Date
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var reminders: [ScanReminder] = [
        ScanReminder(location: "Right Shoulder", dueDate: Date())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack(spacing: 30) {
                    Text("Skin Checkr")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewModel.onStartMainPaywall()
                    }) {
                        HStack(spacing: 8) { // Slightly less space between icon and text
                            Image(systemName: "crown.fill")
                            Text("Get Pro")
                        }
                        .font(.system(size: 16, weight: .semibold)) // Smaller font
                        .foregroundColor(.white)
                        .padding(.horizontal, 25) // Reduced horizontal padding
                        .padding(.vertical, 12)   // Reduced vertical padding
                        .background(Color("skyBlue").opacity(0.2))
                        .cornerRadius(30) // Keeping the large radius for the pill shape
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("lightBlue"), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                    Spacer()
                    
                    Button(action: {
                        viewModel.onShowGetImageView()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Start a New Scan")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .frame(width: 260, height: 60)
                        .foregroundColor(.white)
                        .background(Color("skyBlue"))
                        .cornerRadius(30)
                        .shadow(color: Color("deeperBlue").opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Spacer()
       
             
                }
            }
        }
    }
}


// In HomeView.swift

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Just use the static mock property!
        HomeView(viewModel: .mock)
    }
}
