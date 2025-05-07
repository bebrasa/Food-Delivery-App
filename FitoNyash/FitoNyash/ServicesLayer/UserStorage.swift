//
//  UserStorage.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import Foundation

class UserStorage {
    
    static let shared = UserStorage()
    
    var passedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "passedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "passedOnboarding") }
    }
    
    // MARK: - Favorites
    private let favoritesKey = "favoriteFoodItems"
    
    var favoriteFoodItems: Set<FoodList> {
        get {
            guard let data = UserDefaults.standard.data(forKey: favoritesKey),
                  let decodedItems = try? JSONDecoder().decode(Set<FoodList>.self, from: data) else {
                return []
            }
            return decodedItems
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: favoritesKey)
            }
        }
    }
    
    // MARK: - Cart
    private let cartKey = "cartItems"
    private let cartOrderKey = "cartOrder"
    
    var cartOrder: [FoodList] {
        get {
            guard let data = UserDefaults.standard.data(forKey: cartOrderKey),
                  let decodedItems = try? JSONDecoder().decode([FoodList].self, from: data) else {
                return []
            }
            return decodedItems
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: cartOrderKey)
            }
        }
    }
    
    var cartItems: [FoodList: Int] {
        get {
            guard let data = UserDefaults.standard.data(forKey: cartKey),
                  let decodedItems = try? JSONDecoder().decode([FoodList: Int].self, from: data) else {
                return [:]
            }
            return decodedItems
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: cartKey)
            }
        }
    }
    
    func addToCart(_ item: FoodList) {
        var cart = cartItems
        cart[item, default: 0] += 1
        cartItems = cart
        
        if !cartOrder.contains(item) {
            cartOrder.append(item)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("CartDidChange"), object: nil)
    }
    
    func removeFromCart(_ item: FoodList) {
        var cart = cartItems
        if let count = cart[item] {
            if count > 1 {
                cart[item] = count - 1
            } else {
                cart.removeValue(forKey: item)
                cartOrder.removeAll { $0 == item }
            }
            cartItems = cart
            NotificationCenter.default.post(name: NSNotification.Name("CartDidChange"), object: nil)
        }
    }
    
    func clearCart() {
        cartItems = [:]
        cartOrder = []
        NotificationCenter.default.post(name: NSNotification.Name("CartDidChange"), object: nil)
    }
    
    func toggleFavorite(_ item: FoodList) {
        var favorites = favoriteFoodItems
        if favorites.contains(item) {
            favorites.remove(item)
        } else {
            favorites.insert(item)
        }
        favoriteFoodItems = favorites
    }
    
    func isFavorite(_ item: FoodList) -> Bool {
        return favoriteFoodItems.contains(item)
    }
}
