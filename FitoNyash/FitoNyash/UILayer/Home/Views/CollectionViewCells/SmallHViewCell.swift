//
//  SmallHViewCell.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 03.05.2025.
//

import UIKit

class SmallHViewCell: UICollectionViewCell {
    
    let topView = UIView()
    let bottomLabel = UILabel()
    let imageView = UIImageView()
    var isCategorySelected = false
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: FoodCategories, isSelectedCategory: Bool) {
        bottomLabel.text = category.rawValue
        bottomLabel.font = .Roboto.regular.size(of: 14)
        bottomLabel.textColor = AppColors.labelBlack
        
        isCategorySelected = isSelectedCategory

        var image: UIImage?
        var width: CGFloat = 30
        var height: CGFloat = 30
        
        switch category {
        case .drink:
            image = UIImage(resource: .drinks)
            width = 35.03
            height = 41.36
        case .food:
            image = UIImage(resource: .food)
            width = 42.88
            height = 41.22
        case .snack:
            image = UIImage(resource: .snacks)
            width = 44.24
            height = 31.51
        case .dessert:
            image = UIImage(resource: .dessert)
            width = 38.34
            height = 40.89
        case .salad:
            image = UIImage(resource: .drinks)
            width = 40.89
            height = 38.34
        case .seafood:
            image = UIImage(resource: .drinks)
            width = 35
            height = 20
        case .soup:
            image = UIImage(resource: .drinks)
            width = 20
            height = 20
        case .none:
            print(category)
        }

        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AppColors.categoryGray

        imageWidthConstraint?.isActive = false
        imageHeightConstraint?.isActive = false
        
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: width)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: height)
        
        imageWidthConstraint?.isActive = true
        imageHeightConstraint?.isActive = true
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = isSelectedCategory ? .white : AppColors.categoryGray
            topView.backgroundColor = isSelectedCategory ? AppColors.accentGreen : AppColors.placeholderGrey
    }
    func toggleSelection() {
        isCategorySelected.toggle()
        imageView.tintColor = isCategorySelected ? .white : AppColors.categoryGray
        topView.backgroundColor = isCategorySelected ? AppColors.accentGreen : AppColors.placeholderGrey
    }
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        setupTopView()
        setupBottomLabel()
    }
    
    func setupTopView() {
        contentView.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = AppColors.placeholderGrey
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            topView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.widthAnchor.constraint(equalToConstant: 70),
            topView.heightAnchor.constraint(equalToConstant: 70)
        ])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        topView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    func setupBottomLabel() {
        contentView.addSubview(bottomLabel)
        
        bottomLabel.font = .Roboto.regular.size(of: 14)
        bottomLabel.text = "test label"
        bottomLabel.textColor = .white
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5),
            bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
