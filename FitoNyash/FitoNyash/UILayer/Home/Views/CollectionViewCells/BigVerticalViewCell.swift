//
//  BigVerticalViewCell.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 03.05.2025.
//

import UIKit

class BigVerticalViewCell: UICollectionViewCell {
    
    let topView = UIView()
    let titleView = UILabel()
    let imageView = UIImageView()
    let heartButton = UIButton()
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureVerticalCell(with list: FoodList){
        var image: UIImage?
        var width: CGFloat = 30
        var height: CGFloat = 30
        titleView.text = list.rawValue
        titleView.font = .Roboto.bold.size(of: 14)
        titleView.textColor = AppColors.labelBlack
        
        switch list {
        case .cereal:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .egg:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .filadelphia:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .california:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .salad:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .bananaWithBerries:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .vitaminDrink:
            image = UIImage(resource: .cereal)
            imageView.image = image
            width = 130
            height = 130
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
            ])
        case .none:
            print(list)
        }
        imageView.image = image
        
        imageWidthConstraint?.isActive = false
        imageHeightConstraint?.isActive = false
        
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: width)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: height)
        
        imageWidthConstraint?.isActive = true
        imageHeightConstraint?.isActive = true
    }
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        setupTopView()
        setupBottomLabel()
        setupHeartButton()
    }
    
    func setupTopView() {
        contentView.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = AppColors.bigHorizontalGray
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            topView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.widthAnchor.constraint(equalToConstant: 130),
            topView.heightAnchor.constraint(equalToConstant: 130)
        ])
        topView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupBottomLabel() {
        contentView.addSubview(titleView)
        
        titleView.font = .Roboto.bold.size(of: 14)
        titleView.text = "Овсянка матча-шпинат"
        titleView.textColor = .black
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            titleView.leftAnchor.constraint(equalTo: topView.rightAnchor, constant: 13)
        ])
    }
    
    var onHeartButtonTapped: (() -> Void)?
    func setupHeartButton() {
        contentView.addSubview(heartButton)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        heartButton.setImage(image, for: .normal)
        heartButton.tintColor = AppColors.accentGreen
        
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heartButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            heartButton.leftAnchor.constraint(equalTo: topView.rightAnchor, constant: 13)
            ])
        
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        }
    func updateHeartButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        heartButton.setImage(image, for: .normal)
    }
    @objc private func heartButtonPressed() {
        animateHeart()
        onHeartButtonTapped?()
    }
    private func animateHeart() {
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.heartButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.heartButton.transform = .identity
                           }
                       })
    }
}

