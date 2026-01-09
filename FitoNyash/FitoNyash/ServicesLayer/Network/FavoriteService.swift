//
//  FavoriteService.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

protocol FavoriteServiceProtocol {
    func getFavorites() async throws -> [FoodItemDTO]
    func addToFavorites(foodItemId: Int) async throws -> FoodItemDTO
    func removeFromFavorites(foodItemId: Int) async throws
    func toggleFavorite(foodItemId: Int) async throws -> FoodItemDTO
    func isFavorite(foodItemId: Int) async throws -> Bool
}

class FavoriteService: FavoriteServiceProtocol {
    
    static let shared = FavoriteService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - Get Favorites
    func getFavorites() async throws -> [FoodItemDTO] {
        let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Favorites.all
        )
        
        let favorites = response.data ?? []
        NotificationCenter.default.post(name: .favoritesDidChange, object: favorites)
        
        return favorites
    }
    
    // MARK: - Add to Favorites
    func addToFavorites(foodItemId: Int) async throws -> FoodItemDTO {
        let response: APIResponse<FoodItemDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Favorites.add(foodItemId),
            method: .POST
        )
        guard let item = response.data else {
            throw NetworkError.noData
        }
        
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        
        return item
    }
    
    // MARK: - Remove from Favorites
    func removeFromFavorites(foodItemId: Int) async throws {
        try await networkManager.authorizedRequestVoid(
            endpoint: APIConfig.Favorites.remove(foodItemId),
            method: .DELETE
        )
        
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    // MARK: - Toggle Favorite
    func toggleFavorite(foodItemId: Int) async throws -> FoodItemDTO {
        let response: APIResponse<FoodItemDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Favorites.toggle(foodItemId),
            method: .POST
        )
        guard let item = response.data else {
            throw NetworkError.noData
        }
        
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        
        return item
    }
    
    // MARK: - Check if Favorite
    func isFavorite(foodItemId: Int) async throws -> Bool {
        let response: APIResponse<Bool> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Favorites.check(foodItemId)
        )
        return response.data ?? false
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

