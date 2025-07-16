//
//  ViewModels.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//

import Foundation
import SwiftUI


@MainActor
final class HomeViewModel: ObservableObject {
    let onStartMainPaywall: () -> Void

    init(placePaywall: @escaping () -> Void) {
        self.onStartMainPaywall = placePaywall
    }
    
    
}
