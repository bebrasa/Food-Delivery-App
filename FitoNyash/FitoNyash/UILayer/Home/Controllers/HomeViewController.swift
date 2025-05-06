//
//  HomeViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 03.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    let presenter: HomePresenterProtocol
    private var selectedCategory: FoodCategories?
    private var isHeartTapped = false
    
    //MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchField = FNSearchField()
    private let geoMarkImage = UIImageView()
    private let geoLable = UILabel()
    private let verticalCollectionTitle = FNCollectionTitle()
    lazy var heartButton = UIButton()
    
    
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
        collection.tag = 2
        return collection
    }()
    lazy var bigVerticalCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.tag = 3
        return collection
    }()
    
    //MARK: - Inits
    init(presenter: HomePresenterProtocol) {
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
    }
}

//MARK: - Layout
extension HomeViewController {
    func setupLayout() {
        setupView()
        configureScrollView()
        configureContentView()
        prepareScrollView()
        setupSearchBar()
        setupKeyboardDismissGesture()
        setupGeoMark()
        setupGeoLable()
        setupSmallHCollection()
        setupBigHCollection()
        configureVerticalTitle()
        setupBigVerticalCollection()
        calculateContentSize()
    }
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupView() {
        view.backgroundColor = AppColors.backgroundWhite
    }
    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
    }
    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
    }
    func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    func setupGeoMark() {
        contentView.addSubview(geoMarkImage)
        
        geoMarkImage.image = UIImage(resource: .gps)
        geoMarkImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            geoMarkImage.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            geoMarkImage.heightAnchor.constraint(equalToConstant: 20),
            geoMarkImage.widthAnchor.constraint(equalToConstant: 14),
            geoMarkImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 33)
        ])
    }
    func setupGeoLable() {
        contentView.addSubview(geoLable)
        geoLable.text = "Новосибирск, Пирогова 18, 123Б"
        geoLable.numberOfLines = 0
        geoLable.font = UIFont.Roboto.regular.size(of: 12)
        geoLable.textColor = AppColors.labelBlack
        
        geoLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            geoLable.centerYAnchor.constraint(equalTo: geoMarkImage.centerYAnchor, constant: 0),
            geoLable.leftAnchor.constraint(equalTo: geoMarkImage.rightAnchor, constant: 10),
            geoLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            geoLable.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    func setupSmallHCollection() {
        contentView.addSubview(smallHCollection)
        
        smallHCollection.backgroundColor = .clear
        smallHCollection.translatesAutoresizingMaskIntoConstraints = false
        smallHCollection.delegate = self
        smallHCollection.dataSource = self
        smallHCollection.register(SmallHViewCell.self, forCellWithReuseIdentifier: "SmallHViewCell")
        smallHCollection.clipsToBounds = false
        smallHCollection.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            smallHCollection.topAnchor.constraint(equalTo: geoMarkImage.topAnchor, constant: 50),
            smallHCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            smallHCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            smallHCollection.heightAnchor.constraint(equalToConstant: 91)
        ])
    }
    func setupBigHCollection() {
        contentView.addSubview(bigHCollection)
        
        bigHCollection.backgroundColor = .clear
        bigHCollection.translatesAutoresizingMaskIntoConstraints = false
        bigHCollection.delegate = self
        bigHCollection.dataSource = self
        bigHCollection.register(BigHViewCell.self, forCellWithReuseIdentifier: "BigHViewCell")
        bigHCollection.clipsToBounds = false
        bigHCollection.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            bigHCollection.topAnchor.constraint(equalTo: smallHCollection.bottomAnchor, constant: 52),
            bigHCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            bigHCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bigHCollection.heightAnchor.constraint(equalToConstant: 130*2+20)
        ])
    }
    func configureVerticalTitle() {
        contentView.addSubview(verticalCollectionTitle)
        verticalCollectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalCollectionTitle.topAnchor.constraint(equalTo: bigHCollection.bottomAnchor, constant: 20),
            verticalCollectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            verticalCollectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            verticalCollectionTitle.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    func setupBigVerticalCollection() {
        contentView.addSubview(bigVerticalCollection)
        
        bigVerticalCollection.backgroundColor = .clear
        bigVerticalCollection.translatesAutoresizingMaskIntoConstraints = false
        bigVerticalCollection.delegate = self
        bigVerticalCollection.dataSource = self
        bigVerticalCollection.register(BigVerticalViewCell.self, forCellWithReuseIdentifier: "BigVerticalViewCell")
        
        NSLayoutConstraint.activate([
            bigVerticalCollection.topAnchor.constraint(equalTo: verticalCollectionTitle.bottomAnchor, constant: 26),
            bigVerticalCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            bigVerticalCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            bigVerticalCollection.heightAnchor.constraint(equalToConstant: 1000),
            bigVerticalCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    func calculateContentSize() {
        var totalHeight: CGFloat = 300 + 50 + 22 + 60 +  50 + 20 + 45 + smallHCollection.bounds.height + bigHCollection.bounds.height
        for index in 0..<bigVerticalCollection.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let cellHeight = collectionView(bigVerticalCollection, layout: bigVerticalCollection.collectionViewLayout, sizeForItemAt: indexPath).height
            totalHeight += cellHeight
        }
        let spacing = CGFloat(bigVerticalCollection.numberOfItems(inSection: 0) - 1) * 30
        contentView.heightAnchor.constraint(equalToConstant: totalHeight + spacing).isActive = true
    }
    func setupSearchBar() {
        contentView.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            searchField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - Collection delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return presenter.categoryData.count
        case 2:
            return presenter.foodMenuData.count
        case 3:
            return presenter.foodListData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let category = presenter.categoryData[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallHViewCell", for: indexPath) as? SmallHViewCell
            let isSelected = (category == selectedCategory)
            cell?.configure(with: category, isSelectedCategory: isSelected)
            return cell ?? UICollectionViewCell()
        case 2:
            let menu = presenter.foodMenuData[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigHViewCell", for: indexPath) as? BigHViewCell
            cell?.configureBigHCell(with: menu)
            return cell ?? UICollectionViewCell()
        case 3:
            let foodList = presenter.foodListData[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigVerticalViewCell", for: indexPath) as? BigVerticalViewCell
            cell?.configureVerticalCell(with: foodList)
            let item = presenter.foodListData[indexPath.item]
            cell?.updateHeartButton(isLiked: presenter.isFavorite(at: indexPath.item))

            cell?.onHeartButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.presenter.toggleFavorite(at: indexPath.item)
                cell?.updateHeartButton(isLiked: self.presenter.isFavorite(at: indexPath.item))
            }
            
            return cell ?? UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            let selected = presenter.categoryData[indexPath.row]
            if selectedCategory == selected {
                selectedCategory = nil
            } else {
                selectedCategory = selected
            }
            collectionView.reloadData()
        case 2:
            print()
        case 3:
            print()
        default:
            print()
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
