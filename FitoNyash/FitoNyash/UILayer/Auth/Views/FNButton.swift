//
//  FNButton.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

enum FNButtonStyle {
    case white
    case black
    case green
}

class FNButton: UIView {
    
    private let button = UIButton()
    var action: (() -> Void)?
    var buttonStyle: FNButtonStyle = .white {
        didSet {
            setColorStyle(style: buttonStyle)
        }
    }
    
    init(style: FNButtonStyle = .white) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.backgroundColor = .systemBlue
        setupButton()
    }
    
    private func setupButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Голоден - жми", for: .normal)
        button.titleLabel?.font = .Roboto.bold.size(of: 18)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    @objc private func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
    
    private func setColorStyle(style: FNButtonStyle) {
        switch style {
            case .white:
            button.setTitleColor(AppColors.labelBlack, for: .normal)
            button.backgroundColor = AppColors.backgroundWhite
            case .green:
            button.setTitleColor(AppColors.backgroundWhite, for: .normal)
            button.backgroundColor = AppColors.accentGreen
            case .black:
            button.setTitleColor(AppColors.backgroundWhite, for: .normal)
            button.backgroundColor = AppColors.buttonBlack
        }
    }
}
