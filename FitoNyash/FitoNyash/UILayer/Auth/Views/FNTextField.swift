//
//  FNTextField.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

class FNTextField: UITextField {

    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.layer.cornerRadius = 24
        self.backgroundColor = AppColors.placeholderGrey
        self.font = UIFont.Roboto.regular.size(of: 14)
        
        let placeholderText = "Text to input"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.5),
            .font: UIFont.Roboto.regular.size(of: 14)
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}
