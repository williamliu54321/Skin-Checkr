import Foundation
import AVFoundation
import UIKit
import SwiftUI

/// This ViewModel manages the entire lifecycle of a custom camera interface.
/// It handles camera permissions, session setup, photo capture, and communicates
/// results back to a coordinator view.
///
/// It conforms to `NSObject` and `AVCapturePhotoCaptureDelegate` to receive callbacks from AVFoundation.
/// It is marked with `@MainActor` to ensure all its methods and properties are accessed safely on the main thread,
/// preventing UI-related crashes.
@MainActor
final class CameraInterfaceViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    // MARK: - Properties

    /// The core `AVFoundation` object that manages the capture session.
    /// This is made public so a `CameraPreview` view can use it.
    let session = AVCaptureSession()

    // MARK: - Communication Closures

    /// A closure to execute when the user wants to go back.
    /// This is injected by the parent coordinator.
    let onBack: () -> Void

    /// A closure to execute when a photo has been successfully captured.
    /// It provides the `UIImage` to the parent coordinator.
    let onPhotoTaken: (UIImage) -> Void

    // MARK: - Private Properties

    /// The `AVFoundation` object responsible for capturing a still image.
    private let photoOutput = AVCapturePhotoOutput()

    // MARK: - Initializer

    /// Initializes the ViewModel with communication closures.
    /// - Parameters:
    ///   - onBack: The action to perform when the "Close" button is tapped.
    ///   - onPhotoTaken: The action to perform after a photo is successfully captured.
    init(onBack: @escaping () -> Void, onPhotoTaken: @escaping (UIImage) -> Void) {
        self.onBack = onBack
        self.onPhotoTaken = onPhotoTaken
        super.init()
    }

    // MARK: - Public Methods (Intents from the View)

    /// Starts the camera by checking for permissions and setting up the session.
    /// This should be called from the view's `.onAppear` modifier.
    func startCamera() {
        checkForPermissionsAndSetup()
    }

    /// Triggers the photo capture process.
    /// This should be called when the shutter button is tapped.
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    // MARK: - Private Setup Logic

    /// Checks for camera permissions and proceeds with setup if authorized.
    /// If permissions are not yet determined, it requests them.
    private func checkForPermissionsAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Permission already granted.
            setup()
        case .notDetermined:
            // Permission not yet requested.
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    // Access granted, set up the camera on the main thread.
                    DispatchQueue.main.async {
                        self?.setup()
                    }
                }
            }
        case .denied, .restricted:
            // Permission was denied or restricted.
            // In a real app, you might want to show an alert guiding the user to settings.
            print("Camera access was denied or restricted.")
            break
        @unknown default:
            break
        }
    }

    /// Configures the AVCaptureSession with a camera input and a photo output.
    private func setup() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        // 1. Find the back camera device.
        guard let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Could not find the back camera.")
            session.commitConfiguration()
            return
        }

        // 2. Create an input from the camera device.
        do {
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print("Error creating camera input: \(error.localizedDescription)")
            session.commitConfiguration()
            return
        }

        // 3. Create a photo output.
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        // Finalize the session configuration.
        session.commitConfiguration()

        // *** THE FIX IS HERE ***
        // Start the session on a background thread to avoid freezing the UI.
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    // MARK: - AVCapturePhotoCaptureDelegate

    /// This delegate method is called by AVFoundation when a photo has been processed.
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }

        // Convert the captured photo's data into a UIImage.
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Could not get image data from the captured photo.")
            return
        }

        // Use the `onPhotoTaken` closure to pass the resulting image back to the coordinator.
        self.onPhotoTaken(image)
    }
}
