//
//  ProfilePresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import Foundation

protocol ProfilePresenterProtocol {
    var user: UserDTO? { get }
    var profile: UserProfileDTO? { get }
    var orders: [OrderDTO] { get }
    var delegate: ProfilePresenterDelegate? { get set }
    
    func loadProfile()
    func loadOrders()
    func updateProfile(fullName: String?, phoneNumber: String?, deliveryAddress: String?)
    func logout()
}

protocol ProfilePresenterDelegate: AnyObject {
    func didLoadProfile()
    func didLoadOrders()
    func didUpdateProfile()
    func didLogout()
    func didFailWithError(_ error: Error)
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    let coordinator: ProfileCoordinator
    weak var delegate: ProfilePresenterDelegate?
    
    var user: UserDTO? {
        return TokenStorage.shared.currentUser
    }
    
    private(set) var profile: UserProfileDTO?
    private(set) var orders: [OrderDTO] = []
    
    private let userProfileService = UserProfileService.shared
    private let orderService = OrderService.shared
    private let authService = AuthService.shared
    
    // MARK: - Init
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileDidUpdate),
            name: .profileDidUpdate,
            object: nil
        )
    }
    
    @objc private func profileDidUpdate() {
        loadProfile()
    }
    
    // MARK: - Public Methods
    func loadProfile() {
        guard TokenStorage.shared.isLoggedIn else {
            profile = nil
            delegate?.didLoadProfile()
            return
        }
        
        Task { @MainActor in
            do {
                profile = try await userProfileService.getProfile()
                delegate?.didLoadProfile()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func loadOrders() {
        guard TokenStorage.shared.isLoggedIn else {
            orders = []
            delegate?.didLoadOrders()
            return
        }
        
        Task { @MainActor in
            do {
                orders = try await orderService.getOrders()
                delegate?.didLoadOrders()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func updateProfile(fullName: String?, phoneNumber: String?, deliveryAddress: String?) {
        Task { @MainActor in
            do {
                profile = try await userProfileService.updateProfile(
                    fullName: fullName,
                    phoneNumber: phoneNumber,
                    avatarUrl: nil,
                    deliveryAddress: deliveryAddress
                )
                delegate?.didUpdateProfile()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func logout() {
        Task { @MainActor in
            do {
                try await authService.logout()
                UserStorage.shared.logout()
                delegate?.didLogout()
            } catch {
                // Всё равно выходим локально
                UserStorage.shared.logout()
                delegate?.didLogout()
            }
        }
    }
}
