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
    func startLoader()
    func stopLoader()
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var state: LoginViewState = .base
    var viewOutput: LoginViewOutput!
    
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
    private lazy var loader = UIActivityIndicatorView(style: .large)
    private lazy var loaderContainer = UIView()

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
            view.backgroundColor = .white
            setupSignInPassword()
            setupSignInUsername()
            setupTitleLabel()
            setupSignInButton()
            setupforgotPasswordLabel()
        case .sighUp:
            view.backgroundColor = .white
            setupSignUpPassword()
            setupSignUpReEnterPassword()
            setupSignUpUsername()
            setupSignInButton()
            setupTitleLabel()
        }
        setupLoaderView()
    }
<<<<<<< Updated upstream
=======
    
    //MARK: - Layout
    func setupNavigationBar(){
        let backImage = UIImage(resource: .back)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(navigationController?.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = AppColors.labelBlack
    }
>>>>>>> Stashed changes
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
        case .sighUp:
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
        case .sighUp:
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
    func setupLoaderView() {
        view.addSubview(loaderContainer)
        loaderContainer.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.backgroundColor = AppColors.labelBlack.withAlphaComponent(0.2)
        loaderContainer.isHidden = true
        
        NSLayoutConstraint.activate([
            loaderContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            loaderContainer.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: loaderContainer.centerYAnchor)
        ])
    }
}
//MARK: - Private methods
private extension LoginViewController {
    func onSignInTapped() {
        switch state {
        case .base:
            viewOutput.goToSignIn()
        case .login:
<<<<<<< Updated upstream
            return
        case .sighUp:
=======
            print(#function)
            viewOutput.loginStart(login: signInUsername.text ?? "", password: signInPassword.text ?? "")
        case .signUp:
>>>>>>> Stashed changes
            return
        }
    }
    
    func onSignUpTapped() {
        switch state {
        case .base:
            viewOutput.goToSignUp()
        case .login:
            return
        case .sighUp:
            return
        }
    }
    
    func onForgotTapped() {
        
    }
    
    func onBackPressed() {
        
    }
}

extension LoginViewController: LoginViewInput {
    func startLoader() {
        loaderContainer.isHidden = false
        loader.startAnimating()
    }
    
    func stopLoader() {
        loaderContainer.isHidden = true
        loader.stopAnimating()
    }
}

//#Preview("LoginVC") {
//    LoginViewController(viewOutput: LoginPresenter(), state: .sighUp)
//}
