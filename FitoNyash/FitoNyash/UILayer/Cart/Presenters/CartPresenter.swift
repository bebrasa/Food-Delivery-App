//
//  CartPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import Foundation

protocol CartPresenterProtocol {
    
}

class CartPresenter: CartPresenterProtocol {
    
    //MARK: - Properties
    let coordinator: OrderCoordinator
    
    //MARK: - Inits
    init(coordinator: OrderCoordinator) {
        self.coordinator = coordinator
    }
}
