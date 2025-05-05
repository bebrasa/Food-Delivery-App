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
//    var foodMenuData: [FoodMenuData] { get }
//    var foodListData: [FoodList] { get }
    
}

class HomePresenter: HomePresenterProtocol {
    //MARK: - Properties
    let coordinator: HomeCoordinator
    var categoryData = [FoodCategories]()
    
    //MARK: - Inits
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        getCategoryData()
    }
    
    //MARK: - Methods
    func getSelectedCategory() -> FoodCategories {
        return .none
    }
    private func getCategoryData() {
        categoryData = [.drink, .food, .snack, .dessert, .salad, .seafood, .soup]
    }

}
