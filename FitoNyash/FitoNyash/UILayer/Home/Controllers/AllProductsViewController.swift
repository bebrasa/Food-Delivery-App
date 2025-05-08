import UIKit

final class AllProductsViewController: UIViewController {
    
    // MARK: - Properties
    private var products: [FoodList] = []
    
    // MARK: - UI Elements
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .back), for: .normal)
        button.tintColor = AppColors.buttonBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(BigVerticalViewCell.self, forCellWithReuseIdentifier: "BigVerticalViewCell")
        collection.isScrollEnabled = true
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProducts()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Все блюда"
        view.backgroundColor = AppColors.backgroundWhite
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.hidesBackButton = true
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadProducts() {
        products = [.cereal, .egg, .filadelphia, .california, .salad, .bananaWithBerries, .vitaminDrink]
        collectionView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension AllProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigVerticalViewCell", for: indexPath) as? BigVerticalViewCell else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configureVerticalCell(with: product)
        cell.updateHeartButton(isLiked: UserStorage.shared.isFavorite(product))
        
        cell.onHeartButtonTapped = { [weak cell] in
            UserStorage.shared.toggleFavorite(product)
            cell?.updateHeartButton(isLiked: UserStorage.shared.isFavorite(product))
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesDidChange"), object: nil)
        }
        
        cell.onAddToCartTapped = {
            UserStorage.shared.addToCart(product)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AllProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 130)
    }
} 
 