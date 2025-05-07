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
    let massOfProduct = UILabel()
    let caloryValue = UILabel()
    let productPrice = UILabel()
    let addToCartButton = UIButton()
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
            massOfProduct.text = "220 г"
            caloryValue.text = "КБЖУ: 290/8/7/48"
            productPrice.text = "390 ₽"
            
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
            massOfProduct.text = "180 г"
            caloryValue.text = "КБЖУ: 340/13/21/22"
            productPrice.text = "420 ₽"
            
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
            massOfProduct.text = "250 г"
            caloryValue.text = "КБЖУ: 450/20/18/45"
            productPrice.text = "800 ₽"
            
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
            massOfProduct.text = "300 г"
            caloryValue.text = "КБЖУ: 510/22/16/60"
            productPrice.text = "760 ₽"
            
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
            massOfProduct.text = "200 г"
            caloryValue.text = "КБЖУ: 180/4/9/20"
            productPrice.text = "620 ₽"
            
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
            massOfProduct.text = "280 мл"
            caloryValue.text = "КБЖУ: 180/3/2/40"
            productPrice.text = "350 ₽"
            
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
            massOfProduct.text = "330 мл"
            caloryValue.text = "КБЖУ: 65/0/0/16"
            productPrice.text = "280 ₽"
            
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
        setupMassOfProduct()
        setupCaloryOfProduct()
        setupProductPrice()
        setupCartButton()
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
    var onAddToCartTapped: (() -> Void)?
    
    func setupHeartButton() {
        contentView.addSubview(heartButton)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        heartButton.setImage(image, for: .normal)
        heartButton.tintColor = AppColors.accentGreen
        
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heartButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10),
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
    func setupMassOfProduct() {
        contentView.addSubview(massOfProduct)
        
        massOfProduct.font = .Roboto.regular.size(of: 14)
        massOfProduct.text = "220 г"
        massOfProduct.textColor = AppColors.labelBlack.withAlphaComponent(0.5)
        
        massOfProduct.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            massOfProduct.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            massOfProduct.leftAnchor.constraint(equalTo: topView.rightAnchor, constant: 13)
        ])
    }
    func setupCaloryOfProduct() {
        contentView.addSubview(caloryValue)
        
        caloryValue.font = .Roboto.regular.size(of: 12)
        caloryValue.text = "220 г"
        caloryValue.textColor = AppColors.labelBlack.withAlphaComponent(0.5)
        
        caloryValue.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            caloryValue.topAnchor.constraint(equalTo: massOfProduct.bottomAnchor, constant: 5),
            caloryValue.leftAnchor.constraint(equalTo: topView.rightAnchor, constant: 13)
        ])
    }
    func setupProductPrice() {
        contentView.addSubview(productPrice)
        
        productPrice.font = .Roboto.regular.size(of: 18)
        productPrice.text = "220 г"
        productPrice.textColor = AppColors.labelBlack
        
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productPrice.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10),
            productPrice.leftAnchor.constraint(equalTo: heartButton.rightAnchor, constant: 10)
        ])
    }
    func setupCartButton() {
        contentView.addSubview(addToCartButton)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        addToCartButton.setImage(image, for: .normal)
        addToCartButton.tintColor = AppColors.accentGreen
        
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToCartButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            addToCartButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
        
        addToCartButton.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
    }
    
    @objc private func cartButtonPressed() {
        animateCartButton()
        onAddToCartTapped?()
    }
    
    private func animateCartButton() {
        UIView.animate(withDuration: 0.1,
                      animations: {
            self.addToCartButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.addToCartButton.transform = .identity
            }
        })
    }
}

