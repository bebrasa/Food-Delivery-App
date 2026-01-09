//
//  AuthService.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String, fullName: String?, phoneNumber: String?) async throws -> AuthResponse
    func logout() async throws
    func refreshToken() async throws -> AuthResponse
    var isLoggedIn: Bool { get }
    var currentUser: UserDTO? { get }
}

class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    private let networkManager = NetworkManager.shared
    private let tokenStorage = TokenStorage.shared
    
    private init() {}
    
    // MARK: - Properties
    var isLoggedIn: Bool {
        return tokenStorage.isLoggedIn
    }
    
    var currentUser: UserDTO? {
        return tokenStorage.currentUser
    }
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)
        
        let response: APIResponse<AuthResponse> = try await networkManager.request(
            endpoint: APIConfig.Auth.login,
            method: .POST,
            body: request
        )
        
        guard let authData = response.data else {
            throw NetworkError.noData
        }
        
        // Сохраняем токены и пользователя
        tokenStorage.saveTokens(
            accessToken: authData.accessToken,
            refreshToken: authData.refreshToken
        )
        tokenStorage.saveUser(authData.user)
        
        // Уведомляем о входе
        NotificationCenter.default.post(name: .userDidLogin, object: nil)
        
        return authData
    }
    
    // MARK: - Register
    func register(email: String, password: String, fullName: String?, phoneNumber: String?) async throws -> AuthResponse {
        let request = RegisterRequest(
            email: email,
            password: password,
            fullName: fullName,
            phoneNumber: phoneNumber
        )
        
        let response: APIResponse<AuthResponse> = try await networkManager.request(
            endpoint: APIConfig.Auth.register,
            method: .POST,
            body: request
        )
        
        guard let authData = response.data else {
            throw NetworkError.noData
        }
        
        // Сохраняем токены и пользователя
        tokenStorage.saveTokens(
            accessToken: authData.accessToken,
            refreshToken: authData.refreshToken
        )
        tokenStorage.saveUser(authData.user)
        
        // Уведомляем о входе
        NotificationCenter.default.post(name: .userDidLogin, object: nil)
        
        return authData
    }
    
    // MARK: - Logout
    func logout() async throws {
        do {
            try await networkManager.authorizedRequestVoid(
                endpoint: APIConfig.Auth.logout,
                method: .POST
            )
        } catch {
            // Игнорируем ошибки logout, всё равно очищаем токены
            print("Logout error: \(error)")
        }
        
        // Очищаем локальные данные
        tokenStorage.clearTokens()
        
        // Уведомляем о выходе
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
    
    // MARK: - Refresh Token
    func refreshToken() async throws -> AuthResponse {
        guard let refreshToken = tokenStorage.refreshToken else {
            throw NetworkError.unauthorized
        }
        
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        
        let response: APIResponse<AuthResponse> = try await networkManager.request(
            endpoint: APIConfig.Auth.refresh,
            method: .POST,
            body: request
        )
        
        guard let authData = response.data else {
            throw NetworkError.noData
        }
        
        // Обновляем токены
        tokenStorage.saveTokens(
            accessToken: authData.accessToken,
            refreshToken: authData.refreshToken
        )
        tokenStorage.saveUser(authData.user)
        
        return authData
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
    static let userDidLogout = Notification.Name("userDidLogout")
}

