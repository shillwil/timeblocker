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
    @State private var showUserCreationSuccess = false
    @State private var pickerSelection = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Welcome", selection: $pickerSelection) {
                    Text("Sign Up").tag(0)
                    Text("Sign In").tag(1)
                }
                .pickerStyle(.segmented)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(pickerSelection == 0 ? "Sign Up" : "Sign In") {
                    handleSignIn()
                }
                .disabled(authService.isProcessing)
                
                if authService.isProcessing {
                    ProgressView()
                }
            }
            .padding()
            .navigationTitle(pickerSelection == 0 ? "Sign Up" : "Sign In")
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .alert("User Created", isPresented: $showUserCreationSuccess) {
                Button("OK", role: .cancel) {
                    pickerSelection = 1
                }
            }
            
        }
    }
    
    private func signIn() {
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
    
    private func signUp() {
        Task {
            do {
                try await authService.signUp(email: email, password: password)
            } catch {
                await MainActor.run {
                    errorMessage = (error as? AuthError)?.localizedDescription ?? error.localizedDescription
                    showError = true
                }
            }
            
            showUserCreationSuccess = true
        }
    }
    
    private func handleSignIn() {
        switch pickerSelection {
        case 0:
            signUp()
        case 1:
            signIn()
        default:
            signUp()
        }
    }
    
    private func handleSignOut() {
        
    }
}

#Preview {
    LoginView()
}
