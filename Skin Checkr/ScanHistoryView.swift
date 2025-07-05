//
//  ScanHistoryView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-06.
//

import SwiftUI

struct ScanHistoryView: View {
    // Filter state
    @State private var selectedFilter: HistoryFilter = .all
    
    var body: some View {
        ZStack {
            // Background gradient
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
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        // Home action
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Home")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Scan History")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("[•]")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("skyBlue"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color("skyBlue").opacity(0.1))
                
                // Filter tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        FilterButton(title: "All", isSelected: selectedFilter == .all) {
                            selectedFilter = .all
                        }
                        
                        FilterButton(title: "Pending", isSelected: selectedFilter == .pending) {
                            selectedFilter = .pending
                        }
                        
                        FilterButton(title: "High Risk", isSelected: selectedFilter == .highRisk) {
                            selectedFilter = .highRisk
                        }
                        
                        FilterButton(title: "Med Risk", isSelected: selectedFilter == .medRisk) {
                            selectedFilter = .medRisk
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Sort action
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                }
                
                // Scan history list
                ScrollView {
                    VStack(spacing: 15) {
                        // Pending scan item
                        ScanHistoryItem(
                            photoName: "Unnamed Spot (Back)",
                            dateText: "Captured: Today",
                            riskLevel: .pending,
                            showViewButton: false,
                            showAnalyzeButton: true
                        )
                        
                        // High risk scan item
                        ScanHistoryItem(
                            photoName: "Right Shoulder Mole",
                            dateText: "Analyzed: Today",
                            riskLevel: .high,
                            riskIndicator: "(R) HIGH",
                            showViewButton: true,
                            showAnalyzeButton: false
                        )
                        
                        // Low risk scan item
                        ScanHistoryItem(
                            photoName: "Left Arm Freckle",
                            dateText: "Analyzed: Oct 24",
                            riskLevel: .low,
                            riskIndicator: "(G) LOW",
                            showViewButton: true,
                            showAnalyzeButton: false
                        )
                    }
                    .padding(.vertical, 10)
                }
            }
        }
    }
}

// Filter enum
enum HistoryFilter {
    case all, pending, highRisk, medRisk
}

// Risk Level enum
enum RiskLevel {
    case pending, high, medium, low
}

// Filter Button Component
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? Color("skyBlue") : .white)
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background(isSelected ? Color("skyBlue").opacity(0.2) : Color.clear)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color("lightBlue") : Color.clear, lineWidth: 1)
                )
        }
    }
}

// Scan History Item Component
struct ScanHistoryItem: View {
    let photoName: String
    let dateText: String
    let riskLevel: RiskLevel
    var riskIndicator: String = ""
    let showViewButton: Bool
    let showAnalyzeButton: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 15) {
                // Photo thumbnail
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                    
                    Text("[Photo]")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // Item details
                VStack(alignment: .leading, spacing: 5) {
                    // Title with risk indicator
                    HStack {
                        Text(photoName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if !riskIndicator.isEmpty {
                            Text(riskIndicator)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(riskLevel == .high ? Color.red : (riskLevel == .medium ? Color.orange : Color.green))
                        }
                    }
                    
                    // Date text
                    Text(dateText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Spacer()
                    
                    // Action buttons
                    if showAnalyzeButton {
                        Button(action: {
                            // Analyze action
                        }) {
                            Text("Analyze Now")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(Color("skyBlue"))
                                .cornerRadius(15)
                                .shadow(color: Color("deeperBlue").opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    if showViewButton {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // View action
                            }) {
                                HStack(spacing: 5) {
                                    Text("View")
                                        .font(.system(size: 14, weight: .medium))
                                    Text(">")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundColor(Color("skyBlue"))
                            }
                        }
                    }
                }
                .frame(height: 80)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
            // Divider
            Rectangle()
                .fill(Color("lightBlue").opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
        .background(Color("skyBlue").opacity(0.1))
    }
}

#Preview {
    ScanHistoryView()
}
