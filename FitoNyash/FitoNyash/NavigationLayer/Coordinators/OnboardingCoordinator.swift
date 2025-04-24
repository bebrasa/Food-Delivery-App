//
//  OnboardingCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    
    override func start() {
        showOnboarding()
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
    
}

private extension OnboardingCoordinator {
    func showOnboarding() {
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
        
        pages.append(firstVC)
        pages.append(secondVC)
        pages.append(thirdVC)
        pages.append(fouthVC)
        
        let presenter = OnboardingViewPresenter(coordinator: self)
        let viewController = OnboardingViewController(pages: pages, viewOutput: presenter)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
