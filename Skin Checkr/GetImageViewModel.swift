//
//  GetImageViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-17.
//

// Create a new file: GetImageViewModel.swift

import Foundation

@MainActor
final class GetImageViewModel: ObservableObject {
    let onBack: () -> Void
    let onTakePhoto: () -> Void      // <-- Add this
    let onUploadPhoto: () -> Void // <-- Add this

    init(
        onBack: @escaping () -> Void,
        onTakePhoto: @escaping () -> Void,
        onUploadPhoto: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onTakePhoto = onTakePhoto
        self.onUploadPhoto = onUploadPhoto
    }
}
