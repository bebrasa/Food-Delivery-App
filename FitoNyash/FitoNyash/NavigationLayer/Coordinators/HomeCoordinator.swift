//
//  HomeCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showHomeScene()
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
}

// MARK: - Navigation
extension HomeCoordinator {
    func showHomeScene() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeHomeScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAllProducts() {
        guard let navigationController = navigationController else { return }
        let viewController = AllProductsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
