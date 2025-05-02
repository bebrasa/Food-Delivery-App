//
//  LoginViewPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func loginStart(login: String, password: String)
    func registaionStart()
    func goToSignIn()
    func goToSignUp()
    func goToForgotPassword()
    func back()
}

class LoginPresenter {
    
    private var coordinator: AppCoordinator?
    weak var viewInput: LoginViewInput?
    
    init(coordinator: AppCoordinator? = nil, viewInput: LoginViewInput? = nil) {
        self.coordinator = coordinator
        self.viewInput = viewInput
    }
}

private extension LoginPresenter {
    func goToMainScreen() {
        coordinator?.showMainScreen()
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            DispatchQueue.main.async {
                if login.lowercased( ) == "admin" && password.lowercased() == "12345" {
                    self.viewInput?.stopLoader() 
                    self.goToMainScreen()
                } else {
                    print("wrong pass or log")
                    self.viewInput?.stopLoader()
                }
            }
        }
    }
    func registaionStart() {
        
    }
     
    func goToSignIn() {
        coordinator?.showSignInFlow()
    }
}

        
