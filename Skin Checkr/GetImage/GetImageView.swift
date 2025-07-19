import SwiftUI

struct GetImageView: View {
    
    @ObservedObject var viewModel: GetImageViewModel
    
    // This state variable is not used in the button logic, but keeping it
    // as it was in your original code.
    @State private var savedPhotos: Int = 2
    
    // --> ADDED: A new state variable to control when the photo picker sheet is shown.
    @State private var isShowingPhotoPicker = false
    
    var body: some View {
        ZStack {
        
            VStack(spacing: 15) {
                // Header (No changes here)
                HStack {
                    Button(action: viewModel.onBack) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
                
                // Instructions text (No changes here)
                HStack {
                    Text("Choose a ")
                        .foregroundColor(.white)
                    +
                    Text("method")
                        .foregroundColor(Color("skyBlue"))
                    +
                    Text(" to add a new photo for analysis.")
                        .foregroundColor(.white)
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 20)
                
                // "Take a Photo" Button (No changes here)
                Button(action: viewModel.onTakePhoto) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        Text("Take a Photo")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 15)
                    .background(Color("skyBlue").opacity(0.2))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("lightBlue"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                
                // "Upload from Library" Button
                // --> EDITED: The action now just flips the switch to show the sheet.
                Button(action: {
                    isShowingPhotoPicker = true
                }) {
                    // The UI for this button is completely unchanged.
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        Text("Upload from Library")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 15)
                    .background(Color("skyBlue").opacity(0.2))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("lightBlue"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                
                Spacer()
                                
            }
        }
        // --> ADDED: The .sheet modifier presents the PhotoPicker when the state variable is true.
        .sheet(isPresented: $isShowingPhotoPicker) {
            // This is the content that will appear in the sheet.
            PhotoPicker(
                onCancel: {
                    // When the user cancels, just dismiss the sheet.
                    isShowingPhotoPicker = false
                },
                onPhotoSelected: { image in
                    // When a photo is selected, dismiss the sheet AND
                    // call the ViewModel's closure to pass the image up to the coordinator.
                    isShowingPhotoPicker = false
                    viewModel.onPhotoSelected(image)
                }
            )
        }
    }
}

#Preview {
    // --> EDITED: The preview is updated to use the new ViewModel initializer.
    GetImageView(viewModel: GetImageViewModel(
        onBack: { print("Back Tapped") },
        onTakePhoto: { print("Take Photo Tapped") },
        onPhotoSelected: { image in print("Photo was selected from library: \(image)") }
    ))
}
