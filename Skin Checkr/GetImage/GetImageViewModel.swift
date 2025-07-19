//
//  GetImageViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-17.
//

import SwiftUI // We need to import SwiftUI to use the UIImage type

@MainActor
final class GetImageViewModel: ObservableObject {
    let onBack: () -> Void
    let onTakePhoto: () -> Void
    
    // REMOVED: The old onUploadPhoto is no longer needed because the view
    // itself will trigger the sheet.
    // let onUploadPhoto: () -> Void
    
    // ADDED: A new closure to handle the image AFTER it has been selected.
    // This is the new communication channel back to the AppCoordinator.
    let onPhotoSelected: (UIImage) -> Void

    // UPDATE THE INITIALIZER to match the new properties.
    init(
        onBack: @escaping () -> Void,
        onTakePhoto: @escaping () -> Void,
        onPhotoSelected: @escaping (UIImage) -> Void // <-- New parameter
    )
    {
        self.onBack = onBack
        self.onTakePhoto = onTakePhoto
        self.onPhotoSelected = onPhotoSelected // <-- Assign new parameter
    }
}
