//
//  ProfilePresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.05.2025.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var coordinator: Coordinator? { get set }
    func getUserInfo() -> String
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    weak var coordinator: Coordinator?
    
    // MARK: - Init
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func getUserInfo() -> String {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return username
        } else if let email = UserDefaults.standard.string(forKey: "email") {
            return email
        }
        return "Гость"
    }
}
