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
        showOnboardingFlow()
//        if userStorage.passedOnboarding {
//            showMainFlow()
//        } else {
//            showOnboardingFlow()
//        }
        
//        let loginPresenter = LoginPresenter(coordinator: self)
//        
//        let loginVC = LoginViewController(viewOutput: loginPresenter, state: .base)
//        navigationController?.pushViewController(loginVC, animated: false)
        
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
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .onboarding:
            navigationController?.viewControllers.removeAll()
            showMainFlow()
        case .app:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
