//
//  FNSearchField.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 04.05.2025.
//

import UIKit

class FNSearchField: UITextField {

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
        
        let placeholderText = "Найти еду"
        let imageView = UIImageView(frame: CGRect(x: 20, y: 2, width: 20, height: 20))
        imageView.image = UIImage(resource: .searchItem)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.5),
            .font: UIFont.Roboto.regular.size(of: 14)
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 + 20 + 10, height: 22))
        leftPaddingView.addSubview(imageView)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = leftPaddingView
        self.rightView = paddingView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}
