//
//  AuthManager.swift
//  TimeBlocker
//
//  Created by William Shillingford on 11/29/24.
//

import Foundation
import Security
import Supabase

class TokenManager {
    
    static let shared = TokenManager()
    private let keychainTokenKey = "com.manmademillennial.accessToken"
    private let keychainRefreshTokenKey = "com.manmademillennial.refreshToken"
    
    private func saveTokenToKeychain(token: String, key: String) throws {
        let tokenData = token.data(using: .utf8)!
        
        let tokenQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(tokenQuery as CFDictionary)
        
        let status = SecItemAdd(tokenQuery as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status: status)
        }
    }
    
    func saveToken(token: String, key: TokenKey) throws {
        let key = key == .access ? keychainTokenKey : keychainRefreshTokenKey
        try saveTokenToKeychain(token: token, key: key)
    }
    
    func getTokenFromKeychain(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let tokenData = result as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            return nil
        }
        
        return token
    }
}

enum TokenError: Error {
    case noToken
    case noRefreshToken
    case invalidURL
    case networkError
}

enum KeychainError: Error {
    case saveFailed(status: OSStatus)
    case readFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
}

enum TokenKey {
    case access
    case refresh
}
