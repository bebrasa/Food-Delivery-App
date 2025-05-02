//
//  AppCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class AppCoordinator: Coordinator{
    
    private let userStorage = UserStorage.shared
    private let factory = SceneFactory.self
    
    override func start() {
        //UserStorage.shared.passedOnboarding = false
        if userStorage.passedOnboarding {
            showAuthFlow()
        } else {
            showOnboardingFlow()
        }
        
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
    
}

// MARK: - Navigation methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navigationController = navigationController else { return }
        factory.makeOnboardingFlow(coordinator: self, finishDelegate: self, navigationController: navigationController)
    }
    func showMainFlow() {
        guard let navigationController = navigationController else { return }
        let tabBarController = factory.makeMainFlow(coordinator: self, finishDelegate: self)
        navigationController.pushViewController(tabBarController, animated: true)
    }
    func showAuthFlow() {
        guard let navigationController = navigationController else { return }
        let viewController = factory.makeAuthScene(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator {
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

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .onboarding:
            navigationController?.viewControllers.removeAll()
            showAuthFlow()
        case .app:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
