//
//  ProfileCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class ProfileCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showProfileScene()
    }
    
    override func finish() {
        print("ProfileCoordinator finished")
    }
}

//MARK: - Navigation
extension ProfileCoordinator {
    func showProfileScene() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeProfileScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
