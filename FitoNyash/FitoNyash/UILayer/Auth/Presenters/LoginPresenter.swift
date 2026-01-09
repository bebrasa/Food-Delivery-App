//
//  LoginViewPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func loginStart(login: String, password: String)
    func registaionStart(email: String, password: String, reEnterPassword: String)
    func goToSignIn()
    func goToSignUp()
    func goToForgotPassword()
    func back()
}

protocol LoginViewInput: AnyObject {
    func startLoader()
    func stopLoader()
    func showError(_ message: String)
}

class LoginPresenter {
    
    private var coordinator: LoginCoordinator?
    weak var viewInput: LoginViewInput?
    
    private let authService = AuthService.shared
    
    init(coordinator: LoginCoordinator? = nil, viewInput: LoginViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
    }
}

private extension LoginPresenter {
    func goToMainScreen() {
        coordinator?.finish()
    }
}

extension LoginPresenter: LoginViewOutput {
    func goToSignUp() {
        coordinator?.showSignUpFlow()
    }
    
    func goToForgotPassword() {
        
    }
    
    func back() {
        
    }
    
    func loginStart(login: String, password: String) {
        viewInput?.startLoader()
        
        Task { @MainActor in
            do {
                _ = try await authService.login(email: login, password: password)
                viewInput?.stopLoader()
                goToMainScreen()
            } catch let error as NetworkError {
                viewInput?.stopLoader()
                viewInput?.showError(error.localizedDescription)
            } catch {
                viewInput?.stopLoader()
                viewInput?.showError("Неверный email или пароль")
            }
        }
    }
    
    func registaionStart(email: String, password: String, reEnterPassword: String) {
        viewInput?.startLoader()
        
        // Проверка совпадения паролей
        guard password == reEnterPassword else {
            viewInput?.stopLoader()
            viewInput?.showError("Пароли не совпадают")
            return
        }
        
        // Проверка минимальной длины пароля
        guard password.count >= 5 else {
            viewInput?.stopLoader()
            viewInput?.showError("Пароль должен содержать минимум 5 символов")
            return
        }
        
        Task { @MainActor in
            do {
                _ = try await authService.register(
                    email: email,
                    password: password,
                    fullName: nil,
                    phoneNumber: nil
                )
                viewInput?.stopLoader()
                goToMainScreen()
            } catch let error as NetworkError {
                viewInput?.stopLoader()
                viewInput?.showError(error.localizedDescription)
            } catch {
                viewInput?.stopLoader()
                viewInput?.showError("Ошибка регистрации. Попробуйте позже.")
            }
        }
    }
     
    func goToSignIn() {
        coordinator?.showSignInFlow()
    }
}
