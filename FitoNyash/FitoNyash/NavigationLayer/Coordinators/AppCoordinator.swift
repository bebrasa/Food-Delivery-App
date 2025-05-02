//
//  AppCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class AppCoordinator: Coordinator{
    
    private let userStorage = UserStorage.shared
    
    override func start() {
//        showOnboardingFlow()
//        if userStorage.passedOnboarding {
//            showMainFlow()
//        } else {
//            showOnboardingFlow()
//        }
        
        let loginPresenter = LoginPresenter(coordinator: self)
        
        let loginVC = LoginViewController(viewOutput: loginPresenter, state: .base)
        navigationController?.pushViewController(loginVC, animated: false)
        
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
        guard let navigationController = navigationController else { return }
        
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(type: .home, navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        homeCoordinator.finishDelegate = self
        homeCoordinator.start()
        
        let orderNavigationController = UINavigationController()
        let orderCoordinator = OrderCoordinator(type: .order, navigationController: orderNavigationController)
        orderNavigationController.tabBarItem = UITabBarItem(title: "Order", image: UIImage(systemName: "house"), tag: 1)
        orderCoordinator.finishDelegate = self
        orderCoordinator.start()
        
        let favoriteNavigationController = UINavigationController()
        let favoriteCoordinator = FavoriteCoordinator(type: .favorite, navigationController: favoriteNavigationController)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "Fav", image: UIImage(systemName: "house"), tag: 2)
        favoriteCoordinator.finishDelegate = self
        favoriteCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(type: .profile, navigationController: profileNavigationController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "profile", image: UIImage(systemName: "house"), tag: 3)
        profileCoordinator.finishDelegate = self
        profileCoordinator.start()
        
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(orderCoordinator)
        addChildCoordinator(favoriteCoordinator)
        addChildCoordinator(profileCoordinator)
        
        let tabBarControllers = [homeNavigationController, orderNavigationController, favoriteNavigationController, profileNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
<<<<<<< Updated upstream
=======
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
    func showMainScreen() {
        showMainFlow()
    }
>>>>>>> Stashed changes
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
