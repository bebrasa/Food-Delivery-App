//
//  HomeViewPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 05.05.2025.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var coordinator: Coordinator? { get set }
    var delegate: HomePresenterDelegate? { get set }
    
    // Данные
    var categories: [CategoryDTO] { get }
    var foodItems: [FoodItemDTO] { get }
    var popularItems: [FoodItemDTO] { get }
    
    // Методы
    func loadData()
    func loadFoodItemsByCategory(_ categoryId: Int)
    func isFavorite(itemId: Int) -> Bool
    func toggleFavorite(itemId: Int)
    func addToCart(itemId: Int)
}

protocol HomePresenterDelegate: AnyObject {
    func didLoadCategories()
    func didLoadFoodItems()
    func didUpdateFavorite(itemId: Int, isFavorite: Bool)
    func didAddToCart()
    func didFailWithError(_ error: Error)
}

class HomePresenter: HomePresenterProtocol {
    
    // MARK: - Properties
    weak var coordinator: Coordinator?
    weak var delegate: HomePresenterDelegate?
    
    private(set) var categories: [CategoryDTO] = []
    private(set) var foodItems: [FoodItemDTO] = []
    private(set) var popularItems: [FoodItemDTO] = []
    
    private let foodService = FoodService.shared
    private let favoriteService = FavoriteService.shared
    private let cartService = CartService.shared
    
    // MARK: - Init
    init(coordinator: Coordinator?) {
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
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
    }
    
    @objc private func favoritesDidChange() {
        // Обновляем данные при изменении избранного
        loadData()
    }
    
    // MARK: - Public Methods
    func loadData() {
        Task { @MainActor in
            do {
                // Загружаем категории и блюда параллельно
                async let categoriesTask = foodService.getAllCategories()
                async let foodItemsTask = foodService.getAllFoodItems()
                async let popularTask = foodService.getPopularItems()
                
                categories = try await categoriesTask
                foodItems = try await foodItemsTask
                popularItems = try await popularTask
                
                delegate?.didLoadCategories()
                delegate?.didLoadFoodItems()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func loadFoodItemsByCategory(_ categoryId: Int) {
        Task { @MainActor in
            do {
                foodItems = try await foodService.getFoodItemsByCategory(categoryId)
                delegate?.didLoadFoodItems()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func isFavorite(itemId: Int) -> Bool {
        return foodItems.first(where: { $0.id == itemId })?.isFavorite ?? false
    }
    
    func toggleFavorite(itemId: Int) {
        guard TokenStorage.shared.isLoggedIn else {
            // Показать экран авторизации
            return
        }
        
        Task { @MainActor in
            do {
                let updatedItem = try await favoriteService.toggleFavorite(foodItemId: itemId)
                
                // Обновляем локальный массив
                if let index = foodItems.firstIndex(where: { $0.id == itemId }) {
                    foodItems[index] = updatedItem
                }
                if let index = popularItems.firstIndex(where: { $0.id == itemId }) {
                    popularItems[index] = updatedItem
                }
                
                delegate?.didUpdateFavorite(itemId: itemId, isFavorite: updatedItem.isFavorite ?? false)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func addToCart(itemId: Int) {
        guard TokenStorage.shared.isLoggedIn else {
            // Показать экран авторизации
            return
        }
        
        Task { @MainActor in
            do {
                _ = try await cartService.addToCart(foodItemId: itemId)
                delegate?.didAddToCart()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
}

// MARK: - Legacy Support
extension HomePresenter {
    // Для обратной совместимости со старым кодом
    var categoryData: [FoodCategories] {
        return [.drink, .food, .snack, .dessert, .salad, .seafood, .soup]
    }
    
    var foodMenuData: [FoodMenu] {
        return [.breakfast, .soup, .salad, .sushi, .summer, .fruit, .meat]
    }
    
    var foodListData: [FoodList] {
        return [.cereal, .egg, .filadelphia, .california, .salad, .bananaWithBerries, .vitaminDrink]
    }
    
    func getSelectedCategory() -> FoodCategories {
        return .none
    }
    
    func isFavorite(at index: Int) -> Bool {
        guard index < foodItems.count else { return false }
        return foodItems[index].isFavorite ?? false
    }
    
    func toggleFavorite(at index: Int) {
        guard index < foodItems.count else { return }
        toggleFavorite(itemId: foodItems[index].id)
    }
}
