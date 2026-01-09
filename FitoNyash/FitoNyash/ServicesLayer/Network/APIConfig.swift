//
//  APIConfig.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

enum APIConfig {
    // MARK: - Base URL
    // Измените на ваш адрес сервера
    #if DEBUG
    static let baseURL = "http://localhost:8080/api"
    #else
    static let baseURL = "https://api.fitonyash.ru/api"
    #endif
    
    // MARK: - Endpoints
    enum Auth {
        static let register = "/auth/register"
        static let login = "/auth/login"
        static let refresh = "/auth/refresh"
        static let logout = "/auth/logout"
    }
    
    enum Categories {
        static let all = "/categories"
        static func byId(_ id: Int) -> String { "/categories/\(id)" }
    }
    
    enum Food {
        static let all = "/food"
        static let paginated = "/food/paginated"
        static func byId(_ id: Int) -> String { "/food/\(id)" }
        static func byCategory(_ categoryId: Int) -> String { "/food/category/\(categoryId)" }
        static func byMenuType(_ menuType: String) -> String { "/food/menu/\(menuType)" }
        static let popular = "/food/popular"
        static let new = "/food/new"
        static let search = "/food/search"
    }
    
    enum Cart {
        static let get = "/cart"
        static func add(_ foodItemId: Int) -> String { "/cart/add/\(foodItemId)" }
        static func update(_ foodItemId: Int) -> String { "/cart/update/\(foodItemId)" }
        static func remove(_ foodItemId: Int) -> String { "/cart/remove/\(foodItemId)" }
        static let clear = "/cart/clear"
    }
    
    enum Favorites {
        static let all = "/favorites"
        static func toggle(_ foodItemId: Int) -> String { "/favorites/toggle/\(foodItemId)" }
        static func add(_ foodItemId: Int) -> String { "/favorites/\(foodItemId)" }
        static func remove(_ foodItemId: Int) -> String { "/favorites/\(foodItemId)" }
        static func check(_ foodItemId: Int) -> String { "/favorites/check/\(foodItemId)" }
    }
    
    enum Orders {
        static let all = "/orders"
        static let create = "/orders"
        static func byId(_ id: Int) -> String { "/orders/\(id)" }
        static func byNumber(_ orderNumber: String) -> String { "/orders/number/\(orderNumber)" }
        static func cancel(_ id: Int) -> String { "/orders/\(id)/cancel" }
    }
    
    enum User {
        static let profile = "/user/profile"
        static let changePassword = "/user/change-password"
    }
    
    // MARK: - Timeouts
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 60
}

