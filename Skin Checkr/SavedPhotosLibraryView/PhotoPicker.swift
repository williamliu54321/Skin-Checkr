// Create a new file: PhotoPicker.swift
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    // This view is given the actions to perform when the user finishes.
    let onCancel: () -> Void
    let onPhotoSelected: (UIImage) -> Void

    // The Coordinator handles all communication from the PHPickerViewController.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Create and configure the PHPickerViewController.
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // User can only select one photo
        config.filter = .images   // Only show images, no videos
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator // Set the coordinator to receive events
        return picker
    }
    
    // This is not needed for the photo picker.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    // The Coordinator class acts as the delegate.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        // This is the delegate method called when the user makes a selection or cancels.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // If the user picked nothing (e.g., swiped to dismiss), call onCancel.
            guard let result = results.first else {
                parent.onCancel()
                return
            }
            
            // Request the actual image data from the result.
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        // If we successfully got an image, call onPhotoSelected.
                        self?.parent.onPhotoSelected(image)
                    } else {
                        // If something went wrong, just cancel.
                        print("Photo library error: \(error?.localizedDescription ?? "Unknown error")")
                        self?.parent.onCancel()
                    }
                }
            }
        }
    }
}
