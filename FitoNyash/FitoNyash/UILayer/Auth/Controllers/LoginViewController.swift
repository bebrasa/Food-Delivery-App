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
    case signUp
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
    var viewOutput: LoginViewOutput!
    private var originalY: CGFloat = 0
    
    // MARK: - Views
    private lazy var titleLable = UILabel()
    private lazy var signInUsername = FNTextField()
    private lazy var signInPassword = FNTextField()
    private lazy var signUpUsername = FNTextField()
    private lazy var signUpPassword = FNTextField()
    private lazy var signUpReEnterPassword = FNTextField()
    private lazy var forgotPasswordLabel = UILabel()
    private lazy var logoImage = UIImageView()
    private lazy var signInButton = FNButton()
    private lazy var signUpButton = FNButton()

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
        setupObservers()
        originalY = self.view.frame.origin.y
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            view.backgroundColor = .white
            setupSignInPassword()
            setupSignInUsername()
            setupTitleLabel()
            setupSignInButton()
            setupforgotPasswordLabel()
        case .signUp:
            view.backgroundColor = .white
            setupSignUpPassword()
            setupSignUpReEnterPassword()
            setupSignUpUsername()
            setupSignInButton()
            setupTitleLabel()
        }
    }
    func setupSignInPassword() {
        view.addSubview(signInPassword)
        signInPassword.translatesAutoresizingMaskIntoConstraints = false
        signInPassword.placeholder = "Пароль"
        
        NSLayoutConstraint.activate([
            signInPassword.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            signInPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signInPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signInPassword.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupSignInUsername() {
        view.addSubview(signInUsername)
        signInUsername.translatesAutoresizingMaskIntoConstraints = false
        signInUsername.placeholder = "Почта"
        
        NSLayoutConstraint.activate([
            signInUsername.bottomAnchor.constraint(equalTo: signInPassword.topAnchor, constant: -20),
            signInUsername.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signInUsername.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signInUsername.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLable)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.font = .Roboto.bold.size(of: 24)
        switch state {
        case .login:
            titleLable.text = "Снова ты?"
            NSLayoutConstraint.activate([
                titleLable.bottomAnchor.constraint(equalTo: signInUsername.topAnchor, constant: -26),
                titleLable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
                titleLable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
                titleLable.heightAnchor.constraint(equalToConstant: 50)
            ])
        case .signUp:
            titleLable.text = "Новенький здесь?"
            NSLayoutConstraint.activate([
                titleLable.bottomAnchor.constraint(equalTo: signUpUsername.topAnchor, constant: -26),
                titleLable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
                titleLable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
                titleLable.heightAnchor.constraint(equalToConstant: 50)
            ])
        case .base:
            return
        }

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

        signInButton.layer.cornerRadius = 24
        signInButton.action = onSignInTapped
        
        switch state {
        case .base:
            signInButton.setTitle("Вход")
            signInButton.backgroundColor = AppColors.buttonBlack
            
            NSLayoutConstraint.activate([
                signInButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 84),
                signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
                signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
                signInButton.heightAnchor.constraint(equalToConstant: 50),
                signInButton.widthAnchor.constraint(equalToConstant: 354)
            ])
        case .login:
            signInButton.setTitle("Войти")
            signInButton.backgroundColor = AppColors.accentGreen
            
            NSLayoutConstraint.activate([
                signInButton.topAnchor.constraint(equalTo: signInPassword.bottomAnchor, constant: 30),
                signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
                signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
                signInButton.heightAnchor.constraint(equalToConstant: 50),
                signInButton.widthAnchor.constraint(equalToConstant: 354)
            ])
        case .signUp:
            signInButton.setTitle("Присоединиться")
            signInButton.backgroundColor = AppColors.accentGreen
            
            NSLayoutConstraint.activate([
                signInButton.topAnchor.constraint(equalTo: signUpReEnterPassword.bottomAnchor, constant: 30),
                signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
                signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
                signInButton.heightAnchor.constraint(equalToConstant: 50),
                signInButton.widthAnchor.constraint(equalToConstant: 354)
            ])
        }
    }
    
    func setupforgotPasswordLabel() {
        view.addSubview(forgotPasswordLabel)
        
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordLabel.text = "Забыли пароль?"
        forgotPasswordLabel.font = .Roboto.regular.size(of: 14)
        forgotPasswordLabel.textColor = AppColors.forgotPasswordBlue
        
        NSLayoutConstraint.activate([
            forgotPasswordLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            forgotPasswordLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30)
        ])
        
    }
    
    func setupSignUpPassword() {
        view.addSubview(signUpPassword)
        
        signUpPassword.translatesAutoresizingMaskIntoConstraints = false
        signUpPassword.placeholder = "Пароль"
        
        NSLayoutConstraint.activate([
            signUpPassword.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            signUpPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signUpPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signUpPassword.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupSignUpReEnterPassword() {
        view.addSubview(signUpReEnterPassword)
        
        signUpReEnterPassword.translatesAutoresizingMaskIntoConstraints = false
        signUpReEnterPassword.placeholder = "Повторите пароль"
        
        NSLayoutConstraint.activate([
            signUpReEnterPassword.topAnchor.constraint(equalTo: signUpPassword.bottomAnchor, constant: 20),
            signUpReEnterPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signUpReEnterPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signUpReEnterPassword.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupSignUpUsername() {
        view.addSubview(signUpUsername)
        
        signUpUsername.translatesAutoresizingMaskIntoConstraints = false
        signUpUsername.placeholder = "Почта"
        
        NSLayoutConstraint.activate([
            signUpUsername.bottomAnchor.constraint(equalTo: signUpPassword.topAnchor, constant: -20),
            signUpUsername.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            signUpUsername.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            signUpUsername.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupSignUpButton() {
        view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Регистрация")
        signUpButton.setTitleColor(AppColors.labelBlack)
        signUpButton.backgroundColor = AppColors.backgroundWhite
        signUpButton.layer.cornerRadius = 24
        signUpButton.action = onSignUpTapped
        
        
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
        switch state {
        case .base:
            viewOutput.goToSignIn()
        case .login:
            return
        case .signUp:
            return
        }
    }
    
    func onSignUpTapped() {
        switch state {
        case .base:
            viewOutput.goToSignUp()
        case .login:
            return
        case .signUp:
            return
        }
    }
    
    func onForgotTapped() {
        
    }
    
    func onBackPressed() {
        
    }
    
}

//MARK: - Keyboard
private extension LoginViewController {
    func setupObservers() {
        startKeyboardListening()
        setupTapToHideKeyboard()
    }
    private func startKeyboardListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func setupTapToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        if self.view.frame.origin.y == originalY {
            self.view.frame.origin.y -= keyboardHeight / 2
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = originalY
    }
}

//#Preview("LoginVC") {
//    let presenter = LoginPresenter()
//    let viewController = LoginViewController(viewOutput: presenter, state: .login)
//    presenter.viewInput = viewController
//    return viewController
//}
