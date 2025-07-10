//
//  OnboardingView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var tabSelection: Int = 0
    
    var body: some View {
        VStack {
            // Progress indicators
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(coordinator.currentStep >= index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 20)
            
            // Main content using TabView for gesture navigation
            TabView(selection: $tabSelection) {
                welcomeView
                    .tag(0)
                
                featuresView
                    .tag(1)
                
                privacyView
                    .tag(2)
                
                subscriptionView
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: tabSelection)
            .onChange(of: tabSelection) { newValue in
                coordinator.currentStep = newValue
            }
            .onChange(of: coordinator.currentStep) { newValue in
                tabSelection = newValue
            }
        }
    }
    
    // MARK: - Step Views
    
    private var welcomeView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("onboarding_welcome")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            
            Text("Early Detection Saves Lives")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("SkinCheckr helps you monitor skin changes with medical-grade accuracy")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Navigation buttons
            VStack(spacing: 12) {
                Button(action: { coordinator.next() }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button("Skip All") {
                    coordinator.skipToEnd()
                }
                .font(.subheadline)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
    
    private var featuresView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("onboarding_features")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            
            Text("Analyze Changes Over Time")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("SkinCheckr's AI technology tracks changes in moles, spots, and lesions with precision")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Navigation buttons
            VStack(spacing: 12) {
                Button(action: { coordinator.next() }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button("Skip") {
                    coordinator.skipToEnd()
                }
                .font(.subheadline)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
    
    private var privacyView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("onboarding_privacy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            
            Text("Your Privacy Is Our Priority")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("All scans stay on your device. Your medical data never leaves your phone without your permission")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Navigation buttons
            VStack(spacing: 12) {
                Button(action: { coordinator.next() }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button("Skip") {
                    coordinator.skipToEnd()
                }
                .font(.subheadline)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
    
    private var subscriptionView: some View {
        VStack(spacing: 20) {
            Text("Why Users Choose SkinCheckr Pro")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            
            VStack(alignment: .leading, spacing: 15) {
                BenefitRow(text: "Unlimited skin checks & monitoring")
                BenefitRow(text: "Personalized risk assessment")
                BenefitRow(text: "Comparison with medical database of 100,000+ cases")
                BenefitRow(text: "Export reports for your doctor")
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Medical testimonial
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text("\"An essential tool for regular skin monitoring.\"")
                        .font(.subheadline)
                        .italic()
                    Text("Dr. Emily Johnson, Dermatologist")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: { coordinator.completeOnboarding() }) {
                Text("Start Free Trial")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
}

struct BenefitRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 16))
            
            Text(text)
                .font(.body)
            
            Spacer()
        }
    }
}
