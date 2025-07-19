// Replace the code in this file: SavedPhotosLibraryView.swift
import SwiftUI

struct SavedPhotosLibraryView: View {
    
    @ObservedObject var viewModel: SavedPhotosLibraryViewModel
    
    // This state variable will control when the photo picker sheet is shown.
    @State private var isShowingPhotoPicker = false
    
    var body: some View {
        ZStack {
            // Your background UI is unchanged.
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue"), Color("deeperBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            Circle().fill(Color("skyBlue").opacity(0.3)).frame(width: 250, height: 250).blur(radius: 50).offset(x: -100, y: -150)
            Circle().fill(Color("lightBlue").opacity(0.4)).frame(width: 300, height: 300).blur(radius: 60).offset(x: 150, y: 100)
            
            // Main content
            VStack(spacing: 15) {
                // Header
                HStack {
                    // CONNECTED: The back button now calls the ViewModel.
                    Button(action: viewModel.backButtonTapped) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                            Text("Back").font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Saved Photos").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                    Spacer()
                    Text("(Not Analyzed)").font(.system(size: 14, weight: .medium)).foregroundColor(Color("skyBlue"))
                }
                .padding(.horizontal, 20)
                
                // Selection header
                HStack {
                    Button(action: { /* Future multi-select action */ }) {
                        Text("Select").font(.system(size: 16, weight: .semibold))
                    }
                    Spacer()
                    // CONNECTED: The "Add New" button now triggers the sheet.
                    Button(action: { isShowingPhotoPicker = true }) {
                        HStack {
                            Text("Add New").font(.system(size: 16, weight: .semibold))
                            Text("+").font(.system(size: 18, weight: .semibold))
                        }
                    }
                }
                .foregroundColor(Color("skyBlue"))
                .padding(.horizontal, 30).padding(.vertical, 10)
                
                // Your placeholder photo grid UI is unchanged.
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    // ... Your ForEach loops for placeholder images ...
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Your instruction text is unchanged.
                HStack {
                    Text("Select a photo to ").foregroundColor(.white)
                    + Text("start").foregroundColor(Color("skyBlue"))
                    + Text(" analysis").foregroundColor(.white)
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.bottom, 20)
            }
        }
        // This modifier presents the PhotoPicker sheet when `isShowingPhotoPicker` is true.
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(
                onCancel: {
                    // When the user cancels, just dismiss the sheet.
                    isShowingPhotoPicker = false
                },
                onPhotoSelected: { image in
                    // When a photo is selected, dismiss the sheet AND call the ViewModel's closure.
                    isShowingPhotoPicker = false
                    viewModel.onPhotoSelected(image)
                }
            )
        }
    }
}

#Preview {
    SavedPhotosLibraryView(viewModel: SavedPhotosLibraryViewModel(
        onBack: {},
        onPhotoSelected: { _ in }
    ))
}
