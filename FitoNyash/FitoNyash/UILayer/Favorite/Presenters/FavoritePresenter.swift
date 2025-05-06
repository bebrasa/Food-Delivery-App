//
//  FavoritePresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import Foundation

protocol FavoritePresenterProtocol {
    var favListData: [FoodList] { get }
}

class FavoritePresenter: FavoritePresenterProtocol {
    
    //MARK: - Properties
    let coordinator: FavoriteCoordinator
    var favListData = [FoodList]()
    
    //MARK: - Inits
    init(coordinator: FavoriteCoordinator) {
        self.coordinator = coordinator
        
    }
}
