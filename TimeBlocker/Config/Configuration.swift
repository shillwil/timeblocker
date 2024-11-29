//
//  Configuration.swift
//  TimeBlocker
//
//  Created by William Shillingford on 11/20/24.
//

import Foundation

enum ConfigurationError: Error {
    case missingKey(String)
    case invalidValue(String)
}

enum Configuration {
    enum Keys {
        static let supabaseURL = "SUPABASE_URL"
        static let supabaseAnonKey = "SUPABASE_ANON_KEY"
    }
    
    private static let infoPlistKeys: [String] = [
        Keys.supabaseURL,
        Keys.supabaseAnonKey
    ]
    
    static func validateConfiguration() throws {
        try infoPlistKeys.forEach { key in
            guard Bundle.main.object(forInfoDictionaryKey: key) != nil else {
                throw ConfigurationError.missingKey(key)
            }
        }
    }
    
    static func value<T>(for key: String) throws -> T {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
            throw ConfigurationError.invalidValue(key)
        }
        return value
    }
}

// SecureKeys class to access configuration
final class SecureKeys {
    static let shared = SecureKeys()
    
    private(set) var supabaseURL: URL
    private(set) var supabaseAnonKey: String
    
    private init() {
        // This will crash if values are missing, which is what we want during development
        guard let urlString: String = try? Configuration.value(for: Configuration.Keys.supabaseURL),
              let url = URL(string: urlString.replacingOccurrences(of: "\\", with: "")),
              let anonKey: String = try? Configuration.value(for: Configuration.Keys.supabaseAnonKey) else {
            fatalError("Missing required configuration. Ensure all keys are set in Config.xcconfig")
        }
        
        self.supabaseURL = url
        self.supabaseAnonKey = anonKey
    }
}
