//
//  FavoriteViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    //MARK: - Properties
    let presenter: FavoritePresenterProtocol
    
    //MARK: - Inits
    init(presenter: FavoritePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
