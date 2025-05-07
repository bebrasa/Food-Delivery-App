//
//  HomeViewPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 05.05.2025.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func getSelectedCategory() -> FoodCategories
    var categoryData: [FoodCategories] { get }
    var foodMenuData: [FoodMenu] { get }
    var foodListData: [FoodList] { get }
    func isFavorite(at index: Int) -> Bool
    func toggleFavorite(at index: Int)
}

class HomePresenter: HomePresenterProtocol {
    //MARK: - Properties
    let coordinator: HomeCoordinator
    var categoryData = [FoodCategories]()
    var foodMenuData = [FoodMenu]()
    var foodListData = [FoodList]()
    
    //MARK: - Inits
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        getCategoryData()
        getFoodMenuData()
        getFoodListData()
    }
    
    //MARK: - Methods
    func getSelectedCategory() -> FoodCategories {
        return .none
    }
    
    func toggleFavorite(at index: Int) {
        let item = foodListData[index]
        UserStorage.shared.toggleFavorite(item)
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesDidChange"), object: nil)
    }

    func isFavorite(at index: Int) -> Bool {
        return UserStorage.shared.isFavorite(foodListData[index])
    }
    
    private func getCategoryData() {
        categoryData = [.drink, .food, .snack, .dessert, .salad, .seafood, .soup]
    }
    private func getFoodMenuData() {
        foodMenuData = [.breakfast, .soup, .salad, .sushi, .summer, .fruit, .meat]
    }
    private func getFoodListData() {
        foodListData = [.cereal, .egg, .filadelphia, .california, .salad, .bananaWithBerries, .vitaminDrink]
    }
}
