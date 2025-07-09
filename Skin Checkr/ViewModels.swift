//
//  ViewModels.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//

import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    let authRepository: AuthRepository
    let onLoginSuccess: () -> Void

    init(authRepository: AuthRepository, onLoginSuccess: @escaping () -> Void) {
        self.authRepository = authRepository
        self.onLoginSuccess = onLoginSuccess
    }

    func login(username: String, password: String) async {
        let success = await authRepository.login(username: username, password: password)
        print("success")
        if success {
            onLoginSuccess()
        }
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    let authRepository: AuthRepository
    let onStartWorkout: () -> Void

    init(authRepository: AuthRepository,
         onStartWorkout: @escaping () -> Void) {
        self.authRepository = authRepository
        self.onStartWorkout = onStartWorkout
    }
}
