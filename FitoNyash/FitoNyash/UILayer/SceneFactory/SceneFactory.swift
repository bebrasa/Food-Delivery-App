//
//  SceneFactory.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 27.04.2025.
//

import UIKit


struct SceneFactory {
    
    // MARK: - Onboarding
    static func makeOnboardingFlow(coordinator: AppCoordinator, finishDelegate: CoordinatorFinishDelegate, navigationController: UINavigationController) -> OnboardingCoordinator {
        let onboardingCoordinator = OnboardingCoordinator(type: .onboarding, navigationController: navigationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(onboardingCoordinator)
        return onboardingCoordinator
    }
    // MARK: - Login
    static func makeLoginFlow(coordinator: AppCoordinator, finishDelegate: CoordinatorFinishDelegate, navigationController: UINavigationController) -> LoginCoordinator {
        let loginCoordinator = LoginCoordinator(type: .login, navigationController: navigationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(loginCoordinator)
        return loginCoordinator
    }
    
    static func makeOnboardingScene(coordinator: OnboardingCoordinator) -> OnboardingViewController {
        
        var pages = [UIViewController]()
        
        let firstVC = OnboardingPartViewController()
        firstVC.imageToShow = UIImage(resource: .firstOnboard)
        firstVC.titleText = "Без лишнего"
        firstVC.descriptionText = "Только полезные блюда и никаких\n сюрпризов — ешь то, что видишь"
        
        let secondVC = OnboardingPartViewController()
        secondVC.imageToShow = UIImage(resource: .secondOnboard)
        secondVC.titleText = "За 20 минут"
        secondVC.descriptionText = "Мы не тянем время — привозим горячее"
        
        let thirdVC = OnboardingPartViewController()
        thirdVC.imageToShow = UIImage(resource: .thirdOnboard)
        thirdVC.titleText = "Где ты - там еда"
        thirdVC.descriptionText = "Ты называешь место — мы везём"
        
        let fouthVC = OnboardingPartViewController()
        fouthVC.imageToShow = UIImage(resource: .fouthOnboard)
        fouthVC.titleText = "В пару кликов"
        fouthVC.descriptionText = "Добавь любимое в корзину и оформи\n за пару секунд"
        fouthVC.showExitButton = true
        
        pages.append(firstVC)
        pages.append(secondVC)
        pages.append(thirdVC)
        pages.append(fouthVC)
        
        let presenter = OnboardingViewPresenter(coordinator: coordinator)
        let viewController = OnboardingViewController(pages: pages, viewOutput: presenter)
        
        if let lastPage = pages.last as? OnboardingPartViewController {
            lastPage.onExitTapped = { [weak viewController] in
                viewController?.buttonPressed()
            }
        }
        
        return viewController
        
    }
    
    
    //MARK: - Main
    static func makeMainFlow(coordinator: AppCoordinator, finishDelegate: CoordinatorFinishDelegate) -> TabBarController {
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(type: .home, navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .homePage), tag: 0)
        homeCoordinator.finishDelegate = finishDelegate
        homeCoordinator.start()
        
        let orderNavigationController = UINavigationController()
        let orderCoordinator = OrderCoordinator(type: .order, navigationController: orderNavigationController)
        orderNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .orderPage), tag: 1)
        orderCoordinator.finishDelegate = finishDelegate
        orderCoordinator.start()
        
        let favoriteNavigationController = UINavigationController()
        let favoriteCoordinator = FavoriteCoordinator(type: .favorite, navigationController: favoriteNavigationController)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .favPage), tag: 2)
        favoriteCoordinator.finishDelegate = finishDelegate
        favoriteCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(type: .profile, navigationController: profileNavigationController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .profilePage), tag: 3)
        profileCoordinator.finishDelegate = finishDelegate
        profileCoordinator.start()
        
        coordinator.addChildCoordinator(homeCoordinator)
        coordinator.addChildCoordinator(orderCoordinator)
        coordinator.addChildCoordinator(favoriteCoordinator)
        coordinator.addChildCoordinator(profileCoordinator)
        
        let tabBarControllers = [homeNavigationController, orderNavigationController, favoriteNavigationController, profileNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        
        return tabBarController
    }
    
    //MARK: - Auth scene
    static func makeAuthScene(coordinator: LoginCoordinator) -> LoginViewController {
        let presenter = LoginPresenter(coordinator: coordinator)
        let viewController = LoginViewController(viewOutput: presenter, state: .base)
        presenter.viewInput = viewController
      
        return viewController
    }
    
    static func makeSignInScene(coordinator: LoginCoordinator) -> LoginViewController {
        let presenter = LoginPresenter(coordinator: coordinator)
        let viewController = LoginViewController(viewOutput: presenter, state: .login)
        presenter.viewInput = viewController
        
        return viewController
    }
    
    static func makeSignUpScene(coordinator: LoginCoordinator) -> LoginViewController {
        let presenter = LoginPresenter(coordinator: coordinator)
        let viewController = LoginViewController(viewOutput: presenter, state: .signUp)
        presenter.viewInput = viewController
        
        return viewController
    }
    //MARK: - Home scene
    static func makeHomeScene(coordinator: HomeCoordinator) -> HomeViewController {
        let presenter = HomePresenter(coordinator: coordinator)
        let controller = HomeViewController(presenter: presenter)
        return controller
    }
    
    //MARK: - Favorite scene
    static func makeFavoriteScene(coordinator: FavoriteCoordinator) -> FavoriteViewController {
        let presenter = FavoritePresenter(coordinator: coordinator)
        let controller = FavoriteViewController(presenter: presenter)
        return controller
    }
}
