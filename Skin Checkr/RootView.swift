//
//  RootView 2.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//

import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        switch coordinator.currentScreen {
        case .login:
            coordinator.makeLoginView()
        case .home:
            coordinator.makeHomeView()
        }
    }
}
