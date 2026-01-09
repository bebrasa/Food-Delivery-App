//
//  FoodService.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

protocol FoodServiceProtocol {
    func getAllCategories() async throws -> [CategoryDTO]
    func getAllFoodItems() async throws -> [FoodItemDTO]
    func getFoodItemsByCategory(_ categoryId: Int) async throws -> [FoodItemDTO]
    func getFoodItemsByMenuType(_ menuType: String) async throws -> [FoodItemDTO]
    func getPopularItems() async throws -> [FoodItemDTO]
    func getNewItems() async throws -> [FoodItemDTO]
    func searchItems(query: String) async throws -> [FoodItemDTO]
    func getFoodItem(id: Int) async throws -> FoodItemDTO
}

class FoodService: FoodServiceProtocol {
    
    static let shared = FoodService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - Categories
    func getAllCategories() async throws -> [CategoryDTO] {
        let response: APIResponse<[CategoryDTO]> = try await networkManager.request(
            endpoint: APIConfig.Categories.all
        )
        return response.data ?? []
    }
    
    // MARK: - Food Items
    func getAllFoodItems() async throws -> [FoodItemDTO] {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.all
            )
            return response.data ?? []
        } else {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.request(
                endpoint: APIConfig.Food.all
            )
            return response.data ?? []
        }
    }
    
    func getFoodItemsByCategory(_ categoryId: Int) async throws -> [FoodItemDTO] {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.byCategory(categoryId)
            )
            return response.data ?? []
        } else {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.request(
                endpoint: APIConfig.Food.byCategory(categoryId)
            )
            return response.data ?? []
        }
    }
    
    func getFoodItemsByMenuType(_ menuType: String) async throws -> [FoodItemDTO] {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.byMenuType(menuType)
            )
            return response.data ?? []
        } else {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.request(
                endpoint: APIConfig.Food.byMenuType(menuType)
            )
            return response.data ?? []
        }
    }
    
    func getPopularItems() async throws -> [FoodItemDTO] {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.popular
            )
            return response.data ?? []
        } else {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.request(
                endpoint: APIConfig.Food.popular
            )
            return response.data ?? []
        }
    }
    
    func getNewItems() async throws -> [FoodItemDTO] {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.new
            )
            return response.data ?? []
        } else {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.request(
                endpoint: APIConfig.Food.new
            )
            return response.data ?? []
        }
    }
    
    func searchItems(query: String) async throws -> [FoodItemDTO] {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.search,
                queryParams: ["query": query]
            )
            return response.data ?? []
        } else {
            let response: APIResponse<[FoodItemDTO]> = try await networkManager.request(
                endpoint: APIConfig.Food.search,
                queryParams: ["query": query]
            )
            return response.data ?? []
        }
    }
    
    func getFoodItem(id: Int) async throws -> FoodItemDTO {
        if TokenStorage.shared.isLoggedIn {
            let response: APIResponse<FoodItemDTO> = try await networkManager.authorizedRequest(
                endpoint: APIConfig.Food.byId(id)
            )
            guard let item = response.data else {
                throw NetworkError.noData
            }
            return item
        } else {
            let response: APIResponse<FoodItemDTO> = try await networkManager.request(
                endpoint: APIConfig.Food.byId(id)
            )
            guard let item = response.data else {
                throw NetworkError.noData
            }
            return item
        }
    }
}

