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
    private init() {
        setupDefaultUser()
    }
    
    private func setupDefaultUser() {
        // Проверяем, есть ли уже пользователи
        if users.isEmpty {
            // Добавляем админа только если база пустая
            let adminUser = User(email: "admin", password: "12345")
            users = [adminUser]
        }
    }
    
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
    
    // MARK: - User Management
    private let usersKey = "users"
    private let currentUserKey = "currentUser"
    
    struct User: Codable {
        let email: String
        let password: String
    }
    
    var currentUser: User? {
        get {
            guard let data = UserDefaults.standard.data(forKey: currentUserKey),
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                return nil
            }
            return user
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: currentUserKey)
            }
        }
    }
    
    private var users: [User] {
        get {
            guard let data = UserDefaults.standard.data(forKey: usersKey),
                  let users = try? JSONDecoder().decode([User].self, from: data) else {
                return []
            }
            return users
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: usersKey)
            }
        }
    }
    
    func registerUser(email: String, password: String) -> Bool {
        // Проверяем, не существует ли уже пользователь с таким email
        if users.contains(where: { $0.email == email }) {
            return false
        }
        
        let newUser = User(email: email, password: password)
        var currentUsers = users
        currentUsers.append(newUser)
        users = currentUsers
        return true
    }
    
    func loginUser(email: String, password: String) -> Bool {
        guard let user = users.first(where: { $0.email == email && $0.password == password }) else {
            return false
        }
        
        currentUser = user
        return true
    }
    
    func logout() {
        currentUser = nil
    }
}
