//
//  OrderService.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

protocol OrderServiceProtocol {
    func createOrder(deliveryAddress: String, deliveryNotes: String?, phoneNumber: String?, paymentMethod: PaymentMethod?) async throws -> OrderDTO
    func getOrders(page: Int, size: Int) async throws -> [OrderDTO]
    func getOrder(id: Int) async throws -> OrderDTO
    func getOrderByNumber(_ orderNumber: String) async throws -> OrderDTO
    func cancelOrder(id: Int) async throws -> OrderDTO
}

class OrderService: OrderServiceProtocol {
    
    static let shared = OrderService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - Create Order
    func createOrder(
        deliveryAddress: String,
        deliveryNotes: String? = nil,
        phoneNumber: String? = nil,
        paymentMethod: PaymentMethod? = nil
    ) async throws -> OrderDTO {
        let request = CreateOrderRequest(
            deliveryAddress: deliveryAddress,
            deliveryNotes: deliveryNotes,
            phoneNumber: phoneNumber,
            paymentMethod: paymentMethod?.rawValue
        )
        
        let response: APIResponse<OrderDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Orders.create,
            method: .POST,
            body: request
        )
        guard let order = response.data else {
            throw NetworkError.noData
        }
        
        // Уведомляем о создании заказа
        NotificationCenter.default.post(name: .orderCreated, object: order)
        
        return order
    }
    
    // MARK: - Get Orders
    func getOrders(page: Int = 0, size: Int = 10) async throws -> [OrderDTO] {
        let response: APIResponse<PaginatedResponse<OrderDTO>> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Orders.all,
            queryParams: [
                "page": String(page),
                "size": String(size)
            ]
        )
        return response.data?.content ?? []
    }
    
    // MARK: - Get Order by ID
    func getOrder(id: Int) async throws -> OrderDTO {
        let response: APIResponse<OrderDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Orders.byId(id)
        )
        guard let order = response.data else {
            throw NetworkError.noData
        }
        return order
    }
    
    // MARK: - Get Order by Number
    func getOrderByNumber(_ orderNumber: String) async throws -> OrderDTO {
        let response: APIResponse<OrderDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Orders.byNumber(orderNumber)
        )
        guard let order = response.data else {
            throw NetworkError.noData
        }
        return order
    }
    
    // MARK: - Cancel Order
    func cancelOrder(id: Int) async throws -> OrderDTO {
        let response: APIResponse<OrderDTO> = try await networkManager.authorizedRequest(
            endpoint: APIConfig.Orders.cancel(id),
            method: .POST
        )
        guard let order = response.data else {
            throw NetworkError.noData
        }
        
        NotificationCenter.default.post(name: .orderCancelled, object: order)
        
        return order
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let orderCreated = Notification.Name("orderCreated")
    static let orderCancelled = Notification.Name("orderCancelled")
}

