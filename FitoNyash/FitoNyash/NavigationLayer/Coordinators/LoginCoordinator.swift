//
//  LoginCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 02.05.2025.
//

import UIKit

// MARK: - LoginCoordinator
class LoginCoordinator: Coordinator {
    
    // MARK: - Properties
    private let factory = SceneFactory.self
    
    // MARK: - Methods
    override func start() {
        showAuthScene()
    }
    
    override func finish() {
        print("LoginCoordinator finished")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

// MARK: - Navigation
extension LoginCoordinator {
    func showAuthScene(){
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeAuthScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    func showSignInFlow() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeSignInScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    func showSignUpFlow() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeSignUpScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
