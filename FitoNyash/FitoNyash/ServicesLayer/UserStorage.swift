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
