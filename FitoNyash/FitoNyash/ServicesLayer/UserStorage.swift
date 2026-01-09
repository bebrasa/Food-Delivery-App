//
//  UserStorage.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import Foundation

class UserStorage {
    
    static let shared = UserStorage()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Onboarding
    var passedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "passedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "passedOnboarding") }
    }
    
    // MARK: - Authentication (используем TokenStorage)
    var isLoggedIn: Bool {
        return TokenStorage.shared.isLoggedIn
    }
    
    var currentUser: UserDTO? {
        return TokenStorage.shared.currentUser
    }
    
    // MARK: - Local Cache for Favorites (для офлайн доступа)
    private let favoritesKey = "favoriteFoodItemsCache"
    
    var cachedFavorites: [FoodItemDTO] {
        get {
            guard let data = UserDefaults.standard.data(forKey: favoritesKey),
                  let items = try? JSONDecoder().decode([FoodItemDTO].self, from: data) else {
                return []
            }
            return items
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: favoritesKey)
            }
        }
    }
    
    func updateFavoritesCache(_ favorites: [FoodItemDTO]) {
        cachedFavorites = favorites
    }
    
    func isFavoriteInCache(_ itemId: Int) -> Bool {
        return cachedFavorites.contains { $0.id == itemId }
    }
    
    // MARK: - Local Cache for Cart (для офлайн доступа)
    private let cartCacheKey = "cartItemsCache"
    
    var cachedCart: CartDTO? {
        get {
            guard let data = UserDefaults.standard.data(forKey: cartCacheKey),
                  let cart = try? JSONDecoder().decode(CartDTO.self, from: data) else {
                return nil
            }
            return cart
        }
        set {
            if let cart = newValue, let data = try? JSONEncoder().encode(cart) {
                UserDefaults.standard.set(data, forKey: cartCacheKey)
            } else {
                UserDefaults.standard.removeObject(forKey: cartCacheKey)
            }
        }
    }
    
    func updateCartCache(_ cart: CartDTO) {
        cachedCart = cart
    }
    
    // MARK: - Logout
    func logout() {
        TokenStorage.shared.clearTokens()
        cachedFavorites = []
        cachedCart = nil
    }
    
    // MARK: - Legacy Support (для совместимости со старым кодом)
    // Эти методы можно использовать во время миграции
    
    @available(*, deprecated, message: "Используйте FavoriteService.shared.toggleFavorite()")
    func toggleFavorite(_ item: FoodList) {
        // Оставляем для совместимости
    }
    
    @available(*, deprecated, message: "Используйте FavoriteService.shared.isFavorite()")
    func isFavorite(_ item: FoodList) -> Bool {
        return false
    }
    
    @available(*, deprecated, message: "Используйте CartService.shared.addToCart()")
    func addToCart(_ item: FoodList) {
        // Оставляем для совместимости
    }
    
    @available(*, deprecated, message: "Используйте CartService.shared.removeFromCart()")
    func removeFromCart(_ item: FoodList) {
        // Оставляем для совместимости
    }
    
    @available(*, deprecated, message: "Используйте CartService.shared.clearCart()")
    func clearCart() {
        // Оставляем для совместимости
    }
}
