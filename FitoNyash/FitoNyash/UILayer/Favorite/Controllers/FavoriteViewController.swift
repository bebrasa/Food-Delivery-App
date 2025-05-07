//
//  FavoriteViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    //MARK: - Properties
    let presenter: FavoritePresenterProtocol
    
    //MARK: - Views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока пусто..."
        label.textColor = AppColors.categoryGray
        label.font = UIFont.Roboto.regular.size(of: 16)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Избранное"
        label.textColor = AppColors.labelBlack
        label.font = UIFont.Roboto.regular.size(of: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.categoryGray.withAlphaComponent(0.5)
        return view
    }()
    
    //MARK: - Inits
    init(presenter: FavoritePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: NSNotification.Name("FavoritesDidChange"),
            object: nil
        )
    }
    
    @objc private func favoritesDidChange() {
        (presenter as? FavoritePresenter)?.loadFavorites()
        collectionView.reloadData()
        updateEmptyState()
    }
}

//MARK: - Layout
extension FavoriteViewController {
    func setupLayout() {
        view.backgroundColor = AppColors.backgroundWhite
        setupTopLabel()
        setupSeparatorLine()
        setupCollectionView()
        setupEmptyStateLabel()
    }
    func setupTopLabel() {
        view.addSubview(topTitleLabel)
        
        topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            topTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -33)
        ])
    }
    
    private func setupSeparatorLine() {
        view.addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BigVerticalViewCell.self, forCellWithReuseIdentifier: "BigVerticalViewCell")
        collectionView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupEmptyStateLabel() {
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !presenter.favListData.isEmpty
    }
}

//MARK: - UICollectionViewDelegate & DataSource
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(presenter.favListData.count)")
        updateEmptyState()
        return presenter.favListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigVerticalViewCell", for: indexPath) as? BigVerticalViewCell
        let foodList = presenter.favListData[indexPath.row]
        print("Configuring cell for item: \(foodList)")
        cell?.configureVerticalCell(with: foodList)
        cell?.updateHeartButton(isLiked: true)
        
        cell?.onHeartButtonTapped = { [weak self] in
            guard let self = self else { return }
            (self.presenter as? FavoritePresenter)?.toggleFavorite(at: indexPath.item)
        }
        
        return cell ?? UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = 130.0
        return CGSize(width: width, height: height)
    }
}
