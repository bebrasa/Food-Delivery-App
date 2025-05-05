//
//  BigHViewCell.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 03.05.2025.
//

import UIKit

class BigHViewCell: UICollectionViewCell {
    
    let topView = UIView()
    let titleView = UILabel()
    let imageView = UIImageView()
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureBigHCell(with menu: FoodMenu){
        titleView.text = menu.rawValue
        titleView.font = .Roboto.bold.size(of: 14)
        titleView.textColor = AppColors.labelBlack
        
        var image: UIImage?
        var width: CGFloat = 30
        var height: CGFloat = 30
        
        switch menu {
        case .breakfast:
            image = UIImage(resource: .breakfast)
            imageView.image = image
            width = 110
            height = 170
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 2),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: -20)
            ])
        case .salad:
            image = UIImage(resource: .salad)
            imageView.image = image
            width = 140
            height = 144
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 10),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: -4)
            ])
        case .soup:
            image = UIImage(resource: .soup)
            imageView.image = image
            width = 140
            height = 145
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 10),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: -4)
            ])
        case .sushi:
            image = UIImage(resource: .sushi)
            imageView.image = image
            width = 140
            height = 142
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 0),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: -4)
            ])
        case .summer:
            image = UIImage(resource: .summer)
            imageView.image = image
            width = 146
            height = 149
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 15),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 5)
            ])
        case .fruit:
            image = UIImage(resource: .fruit)
            imageView.image = image
            width = 199
            height = 203
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 20),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: -51)
            ])
        case .meat:
            image = UIImage(resource: .sushi)
            imageView.image = image
            width = 140
            height = 142
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 0),
                imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: -4)
            ])
        case .none:
            print(menu)
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
        
        titleView.font = .Roboto.regular.size(of: 14)
        titleView.text = "title"
        titleView.textColor = .black
        titleView.numberOfLines = 2
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            titleView.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 15),
            titleView.rightAnchor.constraint(lessThanOrEqualTo: topView.rightAnchor, constant: -15)
        ])
    }
}
