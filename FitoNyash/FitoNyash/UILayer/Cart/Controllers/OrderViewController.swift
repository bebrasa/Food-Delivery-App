//
//  OrderViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.05.2025.
//

import UIKit

class OrderViewController: UIViewController {
    
    // MARK: - Properties
    private static var isChecked = true
    
    // MARK: - UI Elements
    private lazy var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .Roboto.bold.size(of: 24)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .Roboto.regular.size(of: 16)
        return label
    }()
    
    private lazy var closeButton: FNButton = {
        let button = FNButton()
        button.setTitle("Закрыть")
        button.backgroundColor = AppColors.buttonBlack
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = AppColors.accentGreen
        title = ""
        navigationItem.hidesBackButton = true
        
        // Добавляем imageView и лейблы
        view.addSubview(statusImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(closeButton)
        
        closeButton.action = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        NSLayoutConstraint.activate([
            statusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75),
            statusImageView.widthAnchor.constraint(equalToConstant: 190),
            statusImageView.heightAnchor.constraint(equalToConstant: 190),
            
            titleLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateImage() {
        let image = OrderViewController.isChecked ? UIImage(resource: .checked) : UIImage(resource: .cancel)
        statusImageView.image = image
        
        if OrderViewController.isChecked {
            titleLabel.text = "Заказ принят!"
            descriptionLabel.text = "Мы уже на кухне — скоро всё будет у тебя"
        } else {
            titleLabel.text = "Что-то пошло не так..."
            descriptionLabel.text = "Попробуйте еще раз позже"
        }
        
        OrderViewController.isChecked.toggle()
    }
}
