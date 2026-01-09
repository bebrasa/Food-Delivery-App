//
//  UserProfileService.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

protocol UserProfileServiceProtocol {
    func getProfile() async throws -> UserProfileDTO
    func updateProfile(fullName: String?, phoneNumber: String?, avatarUrl: String?, deliveryAddress: String?) async throws -> UserProfileDTO
    func changePassword(oldPassword: String, newPassword: String) async throws
}

class UserProfileService: UserProfileServiceProtocol {
    
    static let shared = UserProfileService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - Get Profile
    func getProfile() async throws -> UserProfileDTO {
        let response: APIResponse<UserProfileDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.User.profile
        )
        guard let profile = response.data else {
            throw NetworkError.noData
        }
        return profile
    }
    
    // MARK: - Update Profile
    func updateProfile(
        fullName: String? = nil,
        phoneNumber: String? = nil,
        avatarUrl: String? = nil,
        deliveryAddress: String? = nil
    ) async throws -> UserProfileDTO {
        let request = UpdateProfileRequest(
            fullName: fullName,
            phoneNumber: phoneNumber,
            avatarUrl: avatarUrl,
            deliveryAddress: deliveryAddress
        )
        
        let response: APIResponse<UserProfileDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.User.profile,
            method: .PUT,
            body: request
        )
        guard let profile = response.data else {
            throw NetworkError.noData
        }
        
        // Обновляем локальные данные пользователя
        let userDTO = UserDTO(
            id: profile.id,
            email: profile.email,
            fullName: profile.fullName,
            phoneNumber: profile.phoneNumber,
            avatarUrl: profile.avatarUrl,
            deliveryAddress: profile.deliveryAddress
        )
        TokenStorage.shared.saveUser(userDTO)
        
        NotificationCenter.default.post(name: .profileDidUpdate, object: profile)
        
        return profile
    }
    
    // MARK: - Change Password
    func changePassword(oldPassword: String, newPassword: String) async throws {
        try await networkManager.authorizedRequestVoid(
            endpoint: APIConfig.User.changePassword,
            method: .POST,
            queryParams: [
                "oldPassword": oldPassword,
                "newPassword": newPassword
            ]
        )
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}

