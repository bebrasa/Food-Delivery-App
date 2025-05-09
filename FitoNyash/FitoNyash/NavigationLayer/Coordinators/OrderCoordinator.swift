//
//  OrderCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class OrderCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showCartScene()
    }
    
    override func finish() {
        print("CartCoordinator finished")
    }
    
}

//MARK: - Navigation
extension OrderCoordinator {
    func showCartScene() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeCartScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
