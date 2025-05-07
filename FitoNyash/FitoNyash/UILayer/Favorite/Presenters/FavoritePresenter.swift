//
//  FavoritePresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import Foundation

protocol FavoritePresenterProtocol {
    var favListData: [FoodList] { get }
    func loadFavorites()
    func toggleFavorite(at index: Int)
}

class FavoritePresenter: FavoritePresenterProtocol {
    
    //MARK: - Properties
    let coordinator: FavoriteCoordinator
    var favListData = [FoodList]()
    weak var viewInput: FavoriteViewController?
    
    //MARK: - Inits
    init(coordinator: FavoriteCoordinator) {
        self.coordinator = coordinator
        loadFavorites()
    }
    
    //MARK: - Methods
    func loadFavorites() {
        favListData = Array(UserStorage.shared.favoriteFoodItems)
        print("Loaded favorites: \(favListData)")
    }
    
    func toggleFavorite(at index: Int) {
        let item = favListData[index]
        UserStorage.shared.toggleFavorite(item)
        loadFavorites()
        viewInput?.collectionView.reloadData()
    }
}
