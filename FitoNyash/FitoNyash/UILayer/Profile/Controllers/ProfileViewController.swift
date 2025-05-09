//
//  ProfileViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.05.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: ProfilePresenterProtocol
    
    // MARK: - UI Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .man)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    internal lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Roboto.medium.size(of: 18)
        label.textColor = AppColors.buttonBlack
        label.textAlignment = .center
        return label
    }()
    internal let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль"
        label.textColor = AppColors.labelBlack
        label.font = UIFont.Roboto.regular.size(of: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.categoryGray.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    internal lazy var myOrdersButton = ProfileMenuButtonView(title: "Мои заказы")
    internal lazy var paymentMethodButton = ProfileMenuButtonView(title: "Метод оплаты")
    internal lazy var notificationsButton = ProfileMenuButtonView(title: "Уведомления")
    internal lazy var changePasswordButton = ProfileMenuButtonView(title: "Сменить пароль")
    internal lazy var contactUsButton = ProfileMenuButtonView(title: "Связаться с нами")
    internal lazy var logoutButton = FNButton()
    
    // MARK: - Init
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundWhite
        
        view.addSubview(topTitleLabel)
        view.addSubview(separatorLine)
        view.addSubview(avatarImageView)
        view.addSubview(userInfoLabel)
        view.addSubview(stackView)

        
        setupTopLabel()
        setupSeparatorLine()
        setupMyOrdersButton()
        setupPaymentButton()
        setupNotificButton()
        setupChangePassButton()
        setupContactUsButton()
        setupLogoutButton()
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 162),
            avatarImageView.heightAnchor.constraint(equalToConstant: 162),
            
            userInfoLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            userInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateUserInfo() {
        userInfoLabel.text = presenter.getUserInfo()
    }
    private func setupTopLabel() {
        topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            topTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -33)
        ])
    }
    
    private func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupMyOrdersButton() {
        view.addSubview(myOrdersButton)
        myOrdersButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myOrdersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -35),
            myOrdersButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            myOrdersButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    private func setupPaymentButton() {
        view.addSubview(paymentMethodButton)
        paymentMethodButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paymentMethodButton.topAnchor.constraint(equalTo: myOrdersButton.bottomAnchor, constant: 22),
            paymentMethodButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            paymentMethodButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    private func setupNotificButton() {
        view.addSubview(notificationsButton)
        notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notificationsButton.topAnchor.constraint(equalTo: paymentMethodButton.bottomAnchor, constant: 22),
            notificationsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            notificationsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    private func setupChangePassButton() {
        view.addSubview(changePasswordButton)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changePasswordButton.topAnchor.constraint(equalTo: notificationsButton.bottomAnchor, constant: 22),
            changePasswordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            changePasswordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    private func setupContactUsButton() {
        view.addSubview(contactUsButton)
        contactUsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactUsButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 22),
            contactUsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            contactUsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.layer.cornerRadius = 24
        logoutButton.backgroundColor = AppColors.buttonBlack
        logoutButton.setTitle("Выйти")
        
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.widthAnchor.constraint(equalToConstant: 354)
        ])
    }
}
