//
//  HomeViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 03.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var smallHCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 70, height: 91)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

//MARK: - Layout
extension HomeViewController {
    func setupLayout() {
        setupView()
        setupSmallHCollection()
    }
    func setupView() {
        view.backgroundColor = AppColors.backgroundWhite
    }
    func setupSmallHCollection() {
        view.addSubview(smallHCollection)
        
        smallHCollection.backgroundColor = .red
        smallHCollection.translatesAutoresizingMaskIntoConstraints = false
        smallHCollection.delegate = self
        smallHCollection.dataSource = self
        smallHCollection.register(SmallHViewCell.self, forCellWithReuseIdentifier: "SmallHViewCell")
        
        NSLayoutConstraint.activate([
            smallHCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            smallHCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            smallHCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            smallHCollection.heightAnchor.constraint(equalToConstant: 91)
        ])
    }
}

//MARK: - Collection delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallHViewCell", for: indexPath)
        return cell
    }
    
    
}
