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
    @State private var reminders: [ScanReminder] = [
        ScanReminder(location: "Right Shoulder", dueDate: Date())
    ]
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.13, blue: 0.19),
                    Color(red: 0.16, green: 0.22, blue: 0.28)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background decorative elements
            Circle()
                .fill(Color(red: 0.15, green: 0.62, blue: 0.86, opacity: 0.3))
                .frame(width: 250, height: 250)
                .blur(radius: 50)
                .offset(x: -100, y: -150)
            
            Circle()
                .fill(Color(red: 0.76, green: 0.39, blue: 0.79, opacity: 0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 150, y: 100)
            
            // Main content
            VStack(spacing: 30) {
                // Modern glass header
                Text("Skin Checkr")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
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
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(25)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Glass tab bar
                HStack(spacing: 0) {
                    TabItemGlass(icon: "house.fill", title: "Home", isSelected: true)
                    TabItemGlass(icon: "figure.stand", title: "Body Map", isSelected: false)
                    TabItemGlass(icon: "clock.arrow.circlepath", title: "History", isSelected: false)
                }
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(isSelected ? Color(red: 0.15, green: 0.62, blue: 0.86) : Color.white.opacity(0.7))
        .frame(maxWidth: .infinity)
    }
}

struct SkinScannerView_Previews: PreviewProvider {
    static var previews: some View {
        SkinScannerView()
    }
}
