//
//  FavoriteCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class FavoriteCoordinator: Coordinator {
    
    override func start() {
        let vc = ViewController()
        vc.view.backgroundColor = .green
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
    
}
