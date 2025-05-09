//
//  ProfilePresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.05.2025.
//

import Foundation

protocol ProfilePresenterProtocol {
    var coordinator: Coordinator? { get set }
    func getUserInfo() -> String
}

class ProfilePresenter: ProfilePresenterProtocol {
    func getUserInfo() -> String {
        if let currentUser = UserStorage.shared.currentUser {
            return currentUser.email
        }
        return "Гость"
    }
    
    // MARK: - Properties
    weak var coordinator: Coordinator?
    
    // MARK: - Init
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
}
