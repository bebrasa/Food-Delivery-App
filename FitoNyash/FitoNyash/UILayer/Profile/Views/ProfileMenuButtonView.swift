//
//  ProfileMenuButtonView.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.05.2025.
//

import UIKit

class ProfileMenuButtonView: UIView {
    // MARK: - Properties
    private let button: UIButton
    private let imageView: UIImageView
    
    // MARK: - Init
    init(title: String) {
        button = UIButton(type: .system)
        imageView = UIImageView(image: UIImage(resource: .openButton).withRenderingMode(.alwaysTemplate))
        imageView.tintColor = AppColors.labelBlack
        super.init(frame: .zero)
        
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI(title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .Roboto.regular.size(of: 16)
        button.setTitleColor(AppColors.labelBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -8),
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 6),
            imageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        button.sendActions(for: .touchUpInside)
    }
    
    // MARK: - Public Methods
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
} 
