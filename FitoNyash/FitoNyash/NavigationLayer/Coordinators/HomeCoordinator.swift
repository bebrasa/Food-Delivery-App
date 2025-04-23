//
//  HomeCoordinator.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    override func start() {
        let vc = ViewController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finished")
    }
    
}
