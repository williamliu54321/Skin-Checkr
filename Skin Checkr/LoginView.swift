//
//  LoginView.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-09.
//
import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            Button("Login") {
                Task {
                    await viewModel.login(username: username, password: password)
                }
            }
        }
        .padding()
    }
}



#Preview {
    LoginView(viewModel: LoginViewModel(authRepository: MockAuthRepository(), onLoginSuccess: {}))
}
