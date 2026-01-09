//
//  FavoritePresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import Foundation

protocol FavoritePresenterProtocol {
    var favorites: [FoodItemDTO] { get }
    var delegate: FavoritePresenterDelegate? { get set }
    
    func loadFavorites()
    func toggleFavorite(at index: Int)
    func addToCart(at index: Int)
}

protocol FavoritePresenterDelegate: AnyObject {
    func didLoadFavorites()
    func didRemoveFavorite(at index: Int)
    func didAddToCart()
    func didFailWithError(_ error: Error)
}

class FavoritePresenter: FavoritePresenterProtocol {
    
    // MARK: - Properties
    let coordinator: FavoriteCoordinator
    weak var delegate: FavoritePresenterDelegate?
    
    private(set) var favorites: [FoodItemDTO] = []
    
    private let favoriteService = FavoriteService.shared
    private let cartService = CartService.shared
    
    // Для обратной совместимости
    weak var viewInput: FavoriteViewController?
    var favListData: [FoodList] {
        return [] // Legacy support
    }
    
    // MARK: - Init
    init(coordinator: FavoriteCoordinator) {
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
        loadFavorites()
    }
    
    // MARK: - Public Methods
    func loadFavorites() {
        guard TokenStorage.shared.isLoggedIn else {
            favorites = []
            delegate?.didLoadFavorites()
            return
        }
        
        Task { @MainActor in
            do {
                favorites = try await favoriteService.getFavorites()
                
                // Кэшируем для офлайн доступа
                UserStorage.shared.updateFavoritesCache(favorites)
                
                delegate?.didLoadFavorites()
                viewInput?.collectionView?.reloadData()
            } catch {
                // При ошибке используем кэш
                favorites = UserStorage.shared.cachedFavorites
                delegate?.didLoadFavorites()
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func toggleFavorite(at index: Int) {
        guard index < favorites.count else { return }
        
        let item = favorites[index]
        
        Task { @MainActor in
            do {
                _ = try await favoriteService.toggleFavorite(foodItemId: item.id)
                
                // Удаляем из локального массива
                favorites.remove(at: index)
                delegate?.didRemoveFavorite(at: index)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func addToCart(at index: Int) {
        guard index < favorites.count else { return }
        
        let item = favorites[index]
        
        Task { @MainActor in
            do {
                _ = try await cartService.addToCart(foodItemId: item.id)
                delegate?.didAddToCart()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
}
