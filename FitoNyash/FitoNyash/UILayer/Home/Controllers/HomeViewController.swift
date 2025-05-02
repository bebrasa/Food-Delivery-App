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
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 1
        return collection
    }()
    lazy var bigHCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 3
        return collection
    }()
    lazy var bigVerticalCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 2
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
        setupBigHCollection()
        setupBigVerticalCollection()
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
    func setupBigHCollection() {
        view.addSubview(bigHCollection)
        
        bigHCollection.backgroundColor = .red
        bigHCollection.translatesAutoresizingMaskIntoConstraints = false
        bigHCollection.delegate = self
        bigHCollection.dataSource = self
        bigHCollection.register(BigHViewCell.self, forCellWithReuseIdentifier: "BigHViewCell")
        
        NSLayoutConstraint.activate([
            bigHCollection.topAnchor.constraint(equalTo: smallHCollection.bottomAnchor, constant: 100),
            bigHCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bigHCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bigHCollection.heightAnchor.constraint(equalToConstant: 130*2+20)
        ])
    }
    func setupBigVerticalCollection() {
        view.addSubview(bigVerticalCollection)
        
        bigVerticalCollection.backgroundColor = .red
        bigVerticalCollection.translatesAutoresizingMaskIntoConstraints = false
        bigVerticalCollection.delegate = self
        bigVerticalCollection.dataSource = self
        bigVerticalCollection.register(BigVerticalViewCell.self, forCellWithReuseIdentifier: "BigVerticalViewCell")
        
        NSLayoutConstraint.activate([
            bigVerticalCollection.topAnchor.constraint(equalTo: bigHCollection.bottomAnchor, constant: 50),
            bigVerticalCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bigVerticalCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bigVerticalCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Collection delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return 30
        case 2:
            return 15
        case 3:
            return 15
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallHViewCell", for: indexPath)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigHViewCell", for: indexPath)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigVerticalViewCell", for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            return CGSize(width: 70, height: 91)
        case 2:
            return CGSize(width: 130, height: 130)
        case 3:
            let width = collectionView.bounds.width
            let height = 130.0
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
