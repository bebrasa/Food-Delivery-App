//
//  APIModels.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

// MARK: - Generic API Response
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}

// MARK: - Auth Models
struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let fullName: String?
    let phoneNumber: String?
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let user: UserDTO
}

struct UserDTO: Codable {
    let id: Int
    let email: String
    let fullName: String?
    let phoneNumber: String?
    let avatarUrl: String?
    let deliveryAddress: String?
}

// MARK: - Category Models
struct CategoryDTO: Codable {
    let id: Int
    let name: String
    let nameEn: String?
    let description: String?
    let imageUrl: String?
    let displayOrder: Int?
    let itemsCount: Int?
}

// MARK: - Food Item Models
struct FoodItemDTO: Codable {
    let id: Int
    let name: String
    let description: String?
    let price: Double
    let imageUrl: String?
    let calories: Double?
    let proteins: Double?
    let fats: Double?
    let carbs: Double?
    let weightGrams: Int?
    let cookingTimeMinutes: Int?
    let isAvailable: Bool?
    let isPopular: Bool?
    let isNew: Bool?
    let categoryId: Int?
    let categoryName: String?
    let menuType: String?
    let isFavorite: Bool?
}

// MARK: - Cart Models
struct CartDTO: Codable {
    let id: Int
    let items: [CartItemDTO]
    let totalPrice: Double
    let totalItems: Int
}

struct CartItemDTO: Codable {
    let id: Int
    let foodItemId: Int
    let foodItemName: String
    let foodItemImageUrl: String?
    let price: Double
    let quantity: Int
    let subtotal: Double
}

struct AddToCartRequest: Codable {
    let quantity: Int
}

// MARK: - Order Models
struct CreateOrderRequest: Codable {
    let deliveryAddress: String
    let deliveryNotes: String?
    let phoneNumber: String?
    let paymentMethod: String?
}

struct OrderDTO: Codable {
    let id: Int
    let orderNumber: String
    let items: [OrderItemDTO]
    let status: String
    let totalPrice: Double
    let deliveryAddress: String
    let deliveryNotes: String?
    let phoneNumber: String?
    let paymentMethod: String?
    let isPaid: Bool?
    let createdAt: String?
    let estimatedDeliveryTime: String?
    let deliveredAt: String?
}

struct OrderItemDTO: Codable {
    let id: Int
    let foodItemId: Int
    let foodItemName: String
    let foodItemImageUrl: String?
    let quantity: Int
    let priceAtOrder: Double
    let subtotal: Double
}

// MARK: - User Profile Models
struct UserProfileDTO: Codable {
    let id: Int
    let email: String
    let fullName: String?
    let phoneNumber: String?
    let avatarUrl: String?
    let deliveryAddress: String?
    let createdAt: String?
}

struct UpdateProfileRequest: Codable {
    let fullName: String?
    let phoneNumber: String?
    let avatarUrl: String?
    let deliveryAddress: String?
}

// MARK: - Paginated Response
struct PaginatedResponse<T: Codable>: Codable {
    let content: [T]
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let number: Int
    let first: Bool
    let last: Bool
}

// MARK: - Order Status Enum
enum OrderStatus: String, Codable {
    case pending = "PENDING"
    case confirmed = "CONFIRMED"
    case preparing = "PREPARING"
    case ready = "READY"
    case delivering = "DELIVERING"
    case delivered = "DELIVERED"
    case cancelled = "CANCELLED"
    
    var displayName: String {
        switch self {
        case .pending: return "Ожидает подтверждения"
        case .confirmed: return "Подтвержден"
        case .preparing: return "Готовится"
        case .ready: return "Готов к доставке"
        case .delivering: return "Доставляется"
        case .delivered: return "Доставлен"
        case .cancelled: return "Отменен"
        }
    }
}

// MARK: - Payment Method Enum
enum PaymentMethod: String, Codable {
    case cash = "CASH"
    case card = "CARD"
    case online = "ONLINE"
    
    var displayName: String {
        switch self {
        case .cash: return "Наличные"
        case .card: return "Карта при получении"
        case .online: return "Онлайн оплата"
        }
    }
}

