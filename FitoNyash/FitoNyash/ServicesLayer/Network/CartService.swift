//
//  CartService.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

protocol CartServiceProtocol {
    func getCart() async throws -> CartDTO
    func addToCart(foodItemId: Int, quantity: Int) async throws -> CartDTO
    func updateQuantity(foodItemId: Int, quantity: Int) async throws -> CartDTO
    func removeFromCart(foodItemId: Int) async throws -> CartDTO
    func clearCart() async throws
}

class CartService: CartServiceProtocol {
    
    static let shared = CartService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - Get Cart
    func getCart() async throws -> CartDTO {
        let response: APIResponse<CartDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Cart.get
        )
        guard let cart = response.data else {
            throw NetworkError.noData
        }
        
        // Уведомляем об изменении корзины
        NotificationCenter.default.post(name: .cartDidChange, object: cart)
        
        return cart
    }
    
    // MARK: - Add to Cart
    func addToCart(foodItemId: Int, quantity: Int = 1) async throws -> CartDTO {
        let response: APIResponse<CartDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Cart.add(foodItemId),
            method: .POST,
            queryParams: ["quantity": String(quantity)]
        )
        guard let cart = response.data else {
            throw NetworkError.noData
        }
        
        NotificationCenter.default.post(name: .cartDidChange, object: cart)
        
        return cart
    }
    
    // MARK: - Update Quantity
    func updateQuantity(foodItemId: Int, quantity: Int) async throws -> CartDTO {
        let response: APIResponse<CartDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Cart.update(foodItemId),
            method: .PUT,
            queryParams: ["quantity": String(quantity)]
        )
        guard let cart = response.data else {
            throw NetworkError.noData
        }
        
        NotificationCenter.default.post(name: .cartDidChange, object: cart)
        
        return cart
    }
    
    // MARK: - Remove from Cart
    func removeFromCart(foodItemId: Int) async throws -> CartDTO {
        let response: APIResponse<CartDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Cart.remove(foodItemId),
            method: .DELETE
        )
        guard let cart = response.data else {
            throw NetworkError.noData
        }
        
        NotificationCenter.default.post(name: .cartDidChange, object: cart)
        
        return cart
    }
    
    // MARK: - Clear Cart
    func clearCart() async throws {
        try await networkManager.authorizedRequestVoid(
            endpoint: APIConfig.Cart.clear,
            method: .DELETE
        )
        
        NotificationCenter.default.post(name: .cartDidChange, object: nil)
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let cartDidChange = Notification.Name("cartDidChange")
}

