//
//  LoginViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

enum LoginViewState {
    case base
    case login
    case sighUp
}

protocol LoginViewInput: AnyObject {
    func onSignInTapped()
    func onSignUpTapped()
    func onForgotTapped()
    func onBackPressed()
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var state: LoginViewState = .base
    weak var viewOutput: LoginViewOutput!
    
    // MARK: - Views
    private lazy var textField = FNTextField()
    private lazy var logoImage = UIImageView()
    private lazy var signInButton = FNButton()
    private lazy var signUpButton = FNButton()
//    private lazy var forgotButton = FNButton()

    // MARK: - Inits
    init(viewOutput: LoginViewOutput, state: LoginViewState) {
        self.viewOutput = viewOutput
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.accentGreen
        setupLayout()
    }
    
}

private extension LoginViewController {
    func setupLayout() {
        switch state {
        case .base:
            setupLogoImage()
            setupSignInButton()
            setupSignUpButton()
        case .login:
            setupTextField()
        case .sighUp:
            setupTextField()
        }
    }
    
    func setupTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.widthAnchor.constraint(equalToConstant: 354)
        ])
    }
    func setupLogoImage() {
        view.addSubview(logoImage)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(resource: .treeLogo)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 227),
            logoImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 115),
            logoImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -115),
            logoImage.heightAnchor.constraint(equalToConstant: 163),
            logoImage.widthAnchor.constraint(equalToConstant: 158)
        ])
    }
    func setupSignInButton() {
        view.addSubview(signInButton)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Вход")
        signInButton.backgroundColor = AppColors.buttonBlack
        signInButton.layer.cornerRadius = 24
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 84),
            signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 354)
        ])
    }
    func setupSignUpButton() {
        view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Регистрация")
        signUpButton.setTitleColor(AppColors.labelBlack)
        signUpButton.backgroundColor = AppColors.backgroundWhite
        signUpButton.layer.cornerRadius = 24
        
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUpButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signUpButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 354)
        ])
    }
}

extension LoginViewController: LoginViewInput {
    func onSignInTapped() {
    
    }
    
    func onSignUpTapped() {
        
    }
    
    func onForgotTapped() {
        
    }
    
    func onBackPressed() {
        
    }
    
}

#Preview("LoginVC") {
    LoginViewController(viewOutput: LoginPresenter(), state: .base)
}
