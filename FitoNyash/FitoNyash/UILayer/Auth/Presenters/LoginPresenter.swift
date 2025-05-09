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

class LoginPresenter {
    
    private var coordinator: LoginCoordinator?
    weak var viewInput: LoginViewInput?
    
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
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                if UserStorage.shared.loginUser(email: login, password: password) {
                    self.viewInput?.stopLoader() 
                    self.goToMainScreen()
                } else {
                    self.viewInput?.stopLoader()
                    // TODO: Показать ошибку авторизации
                }
            }
        }
    }
    
    func registaionStart(email: String, password: String, reEnterPassword: String) {
        viewInput?.startLoader()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                if password != reEnterPassword {
                    self.viewInput?.stopLoader()
                    // TODO: Показать ошибку несовпадения паролей
                    return
                }
                
                if UserStorage.shared.registerUser(email: email, password: password) {
                    // После успешной регистрации сразу логиним пользователя
                    _ = UserStorage.shared.loginUser(email: email, password: password)
                    self.viewInput?.stopLoader()
                    self.goToMainScreen()
                } else {
                    self.viewInput?.stopLoader()
                    // TODO: Показать ошибку регистрации
                }
            }
        }
    }
     
    func goToSignIn() {
        coordinator?.showSignInFlow()
    }
}

        
