//
//  LoginView.swift
//  TimeBlocker
//
//  Created by William Shillingford on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authService = AuthService.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign In") {
                    handleSignIn()
                }
                .disabled(authService.isProcessing)
                
                if authService.isProcessing {
                    ProgressView()
                }
            }
            .padding()
            .navigationTitle("Login")
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleSignIn() {
        Task {
            do {
                try await authService.signIn(email: email, password: password)
                
                // Example of using the token with your backend
//                let userData: UserProfile = try await authService.authenticatedRequest(
//                    endpoint: "/api/user/profile"
//                )
                // Handle user data from your backend
                
            } catch {
                await MainActor.run {
                    errorMessage = (error as? AuthError)?.localizedDescription ?? error.localizedDescription
                    showError = true
                }
            }
        }
    }
    
    private func handleSignUp() {
        
    }
    
    private func handleSignOut() {
        
    }
}

#Preview {
    LoginView()
}
