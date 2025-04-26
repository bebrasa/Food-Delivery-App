//
//  LoginViewPresenter.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func loginStart()
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

extension LoginPresenter: LoginViewOutput {
    func goToSignUp() {
        coordinator?.showSignUpFlow()
    }
    
    func goToForgotPassword() {
        
    }
    
    func back() {
        
    }
    
    
    func loginStart() {
        
    }
    func registaionStart() {
        
    }
     
    func goToSignIn() {
        coordinator?.showSignInFlow()
    }
}

        
