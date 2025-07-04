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

struct SkinScannerView: View {
    // Define light blue color palette
    let skyBlue = Color(red: 0.35, green: 0.60, blue: 0.80)          // Sky blue (primary)
    let lightBlue = Color(red: 0.65, green: 0.85, blue: 1.00)        // Light blue (secondary)
    let paleBlue = Color(red: 0.85, green: 0.95, blue: 1.00)         // Pale blue for subtle elements
    let deeperBlue = Color(red: 0.20, green: 0.40, blue: 0.75)       // Deeper blue for contrast
    let darkBlue = Color(red: 0.10, green: 0.25, blue: 0.45)         // Dark blue for backgrounds
    
    @State private var reminders: [ScanReminder] = [
        ScanReminder(location: "Right Shoulder", dueDate: Date())
    ]
    
    var body: some View {
        ZStack {
            // Gradient background with premium purple colors
            LinearGradient(
                gradient: Gradient(colors: [
                    darkBlue,
                    deeperBlue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background decorative elements
            Circle()
                .fill(skyBlue.opacity(0.3))
                .frame(width: 250, height: 250)
                .blur(radius: 50)
                .offset(x: -100, y: -150)
            
            Circle()
                .fill(lightBlue.opacity(0.4))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 150, y: 100)
            
            // Main content
            VStack(spacing: 30) {
                // Modern glass header with glow effect
                Text("Skin Checkr")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                // Tagline
                Text("Advanced AI analysis of your skin condition")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(paleBlue)
                    .padding(.top, -15)
                
                Spacer()
                
                // Glass scan button
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Start a New Scan")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .frame(width: 260, height: 60)
                    .foregroundColor(.white)
                    .background(skyBlue)
                    .cornerRadius(30)
                    .shadow(color: deeperBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
                
                // Glass reminder card
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
                                .background(skyBlue)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(25)
                .background(skyBlue.opacity(0.2))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lightBlue, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                
                Spacer()
                
    
                
                // Glass tab bar
                HStack(spacing: 0) {
                    TabItemGlass(icon: "house.fill", title: "Home", isSelected: true, accentColor: lightBlue)
                    TabItemGlass(icon: "figure.stand", title: "Body Map", isSelected: false, accentColor: lightBlue)
                    TabItemGlass(icon: "clock.arrow.circlepath", title: "History", isSelected: false, accentColor: lightBlue)
                }
                .padding(.vertical, 15)
                .background(skyBlue.opacity(0.2))
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lightBlue, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
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

struct SkinScannerView_Previews: PreviewProvider {
    static var previews: some View {
        SkinScannerView()
    }
}
