//
//  FavoriteCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class FavoriteCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showFavoriteScene()
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
    
}

//MARK: - Navigation
extension FavoriteCoordinator {
    func showFavoriteScene() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeFavoriteScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
