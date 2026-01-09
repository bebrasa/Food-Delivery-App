//
//  TokenStorage.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation
import Security

class TokenStorage {
    
    static let shared = TokenStorage()
    
    private let accessTokenKey = "com.fitonyash.accessToken"
    private let refreshTokenKey = "com.fitonyash.refreshToken"
    private let userKey = "com.fitonyash.currentUser"
    
    private init() {}
    
    // MARK: - Access Token
    var accessToken: String? {
        get { getString(forKey: accessTokenKey) }
        set {
            if let value = newValue {
                saveString(value, forKey: accessTokenKey)
            } else {
                deleteValue(forKey: accessTokenKey)
            }
        }
    }
    
    // MARK: - Refresh Token
    var refreshToken: String? {
        get { getString(forKey: refreshTokenKey) }
        set {
            if let value = newValue {
                saveString(value, forKey: refreshTokenKey)
            } else {
                deleteValue(forKey: refreshTokenKey)
            }
        }
    }
    
    // MARK: - Current User
    var currentUser: UserDTO? {
        get {
            guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(UserDTO.self, from: data)
        }
        set {
            if let user = newValue, let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }
    
    // MARK: - Public Methods
    var isLoggedIn: Bool {
        return accessToken != nil
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func saveUser(_ user: UserDTO) {
        self.currentUser = user
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
        currentUser = nil
    }
    
    // MARK: - Keychain Helpers
    private func saveString(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getString(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    private func deleteValue(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

