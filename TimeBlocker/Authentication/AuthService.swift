//
//  AuthService.swift
//  TimeBlocker
//
//  Created by William Shillingford on 11/20/24.
//

import Foundation
import Supabase
import LocalAuthentication

// MARK: - Custom Auth Errors
enum AuthError: LocalizedError {
    case invalidCredentials
    case sessionExpired
    case networkError(Error)
    case tokenError(String)
    case biometricError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .sessionExpired:
            return "Session expired. Please sign in again"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .tokenError(let message):
            return "Authentication error: \(message)"
        case .biometricError(let error):
            return "Biometric error: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

// MARK: - Auth Service
class AuthService: ObservableObject {
    static let shared = AuthService()
    private let supabaseAuth: SupabaseClient
    
    // Published properties for UI updates
    @Published var authState: AuthState = .undefined
    @Published var isProcessing = false
    
    // Current session information
    private(set) var currentSession: Session?
    private(set) var accessToken: String?
    
    enum AuthState {
        case undefined
        case authenticated
        case notAuthenticated
    }
    
    init() {
        // Initialize Supabase client for auth only
        self.supabaseAuth = SupabaseClient(
            supabaseURL: SecureKeys.shared.supabaseURL,
            supabaseKey: SecureKeys.shared.supabaseAnonKey
        )
        
        // Check initial auth state
        Task {
            await checkAuthState()
            await setupAuthStateListener()
        }
    }
    
    // MARK: - Auth State Management
    
    private func setupAuthStateListener() async {
        await supabaseAuth.auth.onAuthStateChange { [weak self] event, session in
            guard let self = self else { return }
            
            Task { @MainActor in
                switch event {
                case .initialSession:
                    self.handleSession(session)
                case .signedIn:
                    self.handleSession(session)
                case .signedOut:
                    self.clearSession()
                case .tokenRefreshed:
                    self.handleSession(session)
                default:
                    break
                }
            }
        }
    }
    
    @MainActor
    private func handleSession(_ session: Session?) {
        if let session = session {
            self.currentSession = session
            self.accessToken = session.accessToken
            self.authState = .authenticated
        } else {
            clearSession()
        }
    }
    
    @MainActor
    private func clearSession() {
        self.currentSession = nil
        self.accessToken = nil
        self.authState = .notAuthenticated
    }
    
    @MainActor
    private func checkAuthState() async {
        do {
            let session = try await supabaseAuth.auth.session
            handleSession(session)
        } catch {
            clearSession()
        }
    }
    
    // MARK: - Authentication Methods
    
    func signIn(email: String, password: String) async throws {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            try await supabaseAuth.auth.signIn(
                email: email,
                password: password
            )
        } catch {
            throw AuthError.invalidCredentials
        }
    }
    
    func signUp(email: String, password: String) async throws {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let response = try await supabaseAuth.auth.signUp(
                email: email,
                password: password
            )
        } catch {
            throw AuthError.unknown(error)
        }
    }
    
    func signOut() async throws {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            try await supabaseAuth.auth.signOut()
        } catch {
            throw AuthError.unknown(error)
        }
    }
    
    // MARK: - Token Management for Your Backend
    
    func getAuthHeaders() throws -> [String: String] {
        guard let token = accessToken else {
            throw AuthError.tokenError("No valid token")
        }
        return ["Authorization": "Bearer \(token)"]
    }
    
    // MARK: - API Request Helper
    
    func authenticatedRequest<T: Decodable>(endpoint: String, method: String = "GET", body: Data? = nil) async throws -> T {
        guard let token = accessToken else {
            throw AuthError.sessionExpired
        }
        
        var request = URLRequest(url: URL(string: "YOUR_BACKEND_BASE_URL\(endpoint)")!)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError(NSError(domain: "", code: -1))
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            case 401:
                throw AuthError.sessionExpired
            default:
                throw AuthError.networkError(NSError(domain: "", code: httpResponse.statusCode))
            }
        } catch {
            throw AuthError.networkError(error)
        }
    }
}
