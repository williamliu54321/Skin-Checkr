//
//  CameraInterfaceViewModel.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-18.
//

import Foundation

@MainActor
final class CameraInterfaceViewModel: ObservableObject {
    let onBack: () -> Void

    init(
        onBack: @escaping () -> Void,
    )
    {
        self.onBack = onBack
    }
}
