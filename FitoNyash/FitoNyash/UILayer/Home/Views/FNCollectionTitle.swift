//
//  FNCollectionTitle.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 04.05.2025.
//

import UIKit

class FNCollectionTitle: UIControl {
    
    let collTitle = UILabel()
    let viewAll = UIButton()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FNCollectionTitle {
    func setupLayout() {
        configureView()
        configureTitle()
        configureButton()
    }
    func configureView(){
        self.backgroundColor = .clear
    }
    func configureTitle(){
        addSubview(collTitle)
        collTitle.font = UIFont.Roboto.bold.size(of: 18)
        collTitle.text = "Популярное"
        
        collTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collTitle.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    func configureButton(){
        addSubview(viewAll)
        
        viewAll.translatesAutoresizingMaskIntoConstraints = false
        viewAll.titleLabel?.font = .Roboto.regular.size(of: 12)
        viewAll.setTitle("Больше", for: .normal)
        viewAll.setTitleColor(AppColors.labelBlack, for: .normal)
        
        NSLayoutConstraint.activate([
            viewAll.centerYAnchor.constraint(equalTo: collTitle.centerYAnchor, constant: 0),
            viewAll.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            viewAll.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
