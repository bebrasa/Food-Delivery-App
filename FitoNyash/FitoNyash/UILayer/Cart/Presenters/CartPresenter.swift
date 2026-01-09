//
//  CartPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import Foundation

protocol CartPresenterProtocol {
    var cart: CartDTO? { get }
    var delegate: CartPresenterDelegate? { get set }
    
    func loadCart()
    func updateQuantity(at index: Int, quantity: Int)
    func removeItem(at index: Int)
    func clearCart()
    func createOrder(deliveryAddress: String, deliveryNotes: String?, phoneNumber: String?)
}

protocol CartPresenterDelegate: AnyObject {
    func didLoadCart()
    func didUpdateCart()
    func didRemoveItem(at index: Int)
    func didClearCart()
    func didCreateOrder(_ order: OrderDTO)
    func didFailWithError(_ error: Error)
}

class CartPresenter: CartPresenterProtocol {
    
    // MARK: - Properties
    let coordinator: OrderCoordinator
    weak var delegate: CartPresenterDelegate?
    
    private(set) var cart: CartDTO?
    
    private let cartService = CartService.shared
    private let orderService = OrderService.shared
    
    // MARK: - Init
    init(coordinator: OrderCoordinator) {
        self.coordinator = coordinator
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidChange(_:)),
            name: .cartDidChange,
            object: nil
        )
    }
    
    @objc private func cartDidChange(_ notification: Notification) {
        if let updatedCart = notification.object as? CartDTO {
            cart = updatedCart
            delegate?.didUpdateCart()
        } else {
            loadCart()
        }
    }
    
    // MARK: - Public Methods
    func loadCart() {
        guard TokenStorage.shared.isLoggedIn else {
            cart = nil
            delegate?.didLoadCart()
            return
        }
        
        Task { @MainActor in
            do {
                cart = try await cartService.getCart()
                
                // Кэшируем для офлайн доступа
                if let cart = cart {
                    UserStorage.shared.updateCartCache(cart)
                }
                
                delegate?.didLoadCart()
            } catch {
                // При ошибке используем кэш
                cart = UserStorage.shared.cachedCart
                delegate?.didLoadCart()
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func updateQuantity(at index: Int, quantity: Int) {
        guard let items = cart?.items, index < items.count else { return }
        
        let item = items[index]
        
        Task { @MainActor in
            do {
                cart = try await cartService.updateQuantity(foodItemId: item.foodItemId, quantity: quantity)
                delegate?.didUpdateCart()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func removeItem(at index: Int) {
        guard let items = cart?.items, index < items.count else { return }
        
        let item = items[index]
        
        Task { @MainActor in
            do {
                cart = try await cartService.removeFromCart(foodItemId: item.foodItemId)
                delegate?.didRemoveItem(at: index)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func clearCart() {
        Task { @MainActor in
            do {
                try await cartService.clearCart()
                cart = nil
                UserStorage.shared.cachedCart = nil
                delegate?.didClearCart()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func createOrder(deliveryAddress: String, deliveryNotes: String?, phoneNumber: String?) {
        Task { @MainActor in
            do {
                let order = try await orderService.createOrder(
                    deliveryAddress: deliveryAddress,
                    deliveryNotes: deliveryNotes,
                    phoneNumber: phoneNumber,
                    paymentMethod: .cash
                )
                
                // Корзина автоматически очистится через уведомление
                delegate?.didCreateOrder(order)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
}
