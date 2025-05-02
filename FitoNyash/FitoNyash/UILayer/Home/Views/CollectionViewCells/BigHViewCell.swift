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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.backgroundColor = .blue
        
        setupTopView()
        setupBottomLabel()
    }
    
    func setupTopView() {
        contentView.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .green
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            topView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.widthAnchor.constraint(equalToConstant: 130),
            topView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
    }
    func setupBottomLabel() {
        contentView.addSubview(titleView)
        
        titleView.font = .Roboto.regular.size(of: 14)
        titleView.text = "title"
        titleView.textColor = .black
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            titleView.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 15)
        ])
    }
}
