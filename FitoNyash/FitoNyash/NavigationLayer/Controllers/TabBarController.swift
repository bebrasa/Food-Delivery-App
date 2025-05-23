//
//  TabBarController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class TabBarController: UITabBarController {
    
    init(tabBarControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            self.addChild(tab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = AppColors.backgroundWhite
        tabBar.tintColor = AppColors.accentGreen
        tabBar.itemPositioning = .centered
        tabBar.itemWidth = 22.0
        tabBar.itemSpacing = 66.5
        
    }
}
