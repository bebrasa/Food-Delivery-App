//
//  AppCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class AppCoordinator: Coordinator{
    
    override func start() {
        showOnboardingFlow()
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
    
}

// MARK: - Navigation methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navigationController = navigationController else { return }
        let onboardingCoordinator = OnboardingCoordinator(type: .onboarding, navigationController: navigationController, finishDelegate: self)
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    func showMainFlow() {
        
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .app:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
