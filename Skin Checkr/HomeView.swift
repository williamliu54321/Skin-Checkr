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
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Reminder")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.white.opacity(0.7))
                        
                        Text("Time to re-scan your \"Right Shoulder\" mole.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Scan Now")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color("skyBlue"))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(25)
                    .background(Color("skyBlue").opacity(0.2))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("lightBlue"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        TabItemGlass(icon: "house.fill", title: "Home", isSelected: true, accentColor: Color("lightBlue"))
                        TabItemGlass(icon: "figure.stand", title: "Body Map", isSelected: false, accentColor: Color("lightBlue"))
                        TabItemGlass(icon: "clock.arrow.circlepath", title: "History", isSelected: false, accentColor: Color("lightBlue"))
                    }
                    .padding(.vertical, 15)
                    .background(Color("skyBlue").opacity(0.2))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color("lightBlue"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}


struct TabItemGlass: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(isSelected ? accentColor : Color.white.opacity(0.7))
        .frame(maxWidth: .infinity)
    }
}

// In HomeView.swift

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Just use the static mock property!
        HomeView(viewModel: .mock)
    }
}
