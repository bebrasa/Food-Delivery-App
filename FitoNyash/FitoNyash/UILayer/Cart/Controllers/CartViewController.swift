//
//  CartViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 07.05.2025.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: - Properties
    let presenter: CartPresenterProtocol
    
    // MARK: - Views
    let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина"
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
    
    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока пусто..."
        label.textColor = AppColors.categoryGray
        label.font = UIFont.Roboto.regular.size(of: 16)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого: 0 ₽"
        label.textColor = AppColors.labelBlack
        label.font = UIFont.Roboto.regular.size(of: 18)
        return label
    }()
    
    let orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Заказать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.Roboto.regular.size(of: 16)
        button.backgroundColor = AppColors.accentGreen
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var loader = UIActivityIndicatorView(style: .large)
    private lazy var loaderContainer = UIView()
    
    // MARK: - Inits
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotifications()
        updateEmptyState()
        updateTotalPrice()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidChange),
            name: NSNotification.Name("CartDidChange"),
            object: nil
        )
    }
    
    @objc private func cartDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.reloadData()
                self.updateEmptyState()
                self.updateTotalPrice()
            }
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = UserStorage.shared.cartOrder.isEmpty
        
        UIView.animate(withDuration: 0.3) {
            self.emptyStateLabel.alpha = isEmpty ? 1.0 : 0.0
            self.emptyStateLabel.isHidden = !isEmpty
            self.totalPriceLabel.alpha = isEmpty ? 0.0 : 1.0
            self.orderButton.alpha = isEmpty ? 0.0 : 1.0
        }
    }
    
    private func updateTotalPrice() {
        var totalPrice = 0
        for (food, quantity) in UserStorage.shared.cartItems {
            let price: Int
            switch food {
            case .cereal:
                price = 390
            case .filadelphia:
                price = 800
            case .california:
                price = 760
            case .bananaWithBerries:
                price = 350
            case .vitaminDrink:
                price = 280
            case .none:
                price = 0
            case .egg:
                price = 420
            case .salad:
                price = 620
            }
            totalPrice += price * quantity
        }
        totalPriceLabel.text = "Итого: \(totalPrice) ₽"
    }
    
    private func setupOrderButton() {
        view.addSubview(orderButton)
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.addTarget(self, action: #selector(onOrderButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            orderButton.centerYAnchor.constraint(equalTo: totalPriceLabel.centerYAnchor, constant: 0),
            orderButton.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -150),
            orderButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            orderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLoaderView() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        window.addSubview(loaderContainer)
        loaderContainer.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.backgroundColor = AppColors.labelBlack.withAlphaComponent(0.2)
        loaderContainer.isHidden = true
        
        NSLayoutConstraint.activate([
            loaderContainer.topAnchor.constraint(equalTo: window.topAnchor),
            loaderContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            loaderContainer.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            loaderContainer.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: loaderContainer.centerYAnchor)
        ])
    }
    
    private func startLoader() {
        loaderContainer.isHidden = false
        loader.startAnimating()
    }
    
    private func stopLoader() {
        loaderContainer.isHidden = true
        loader.stopAnimating()
    }
    
    @objc private func onOrderButtonTapped() {
        startLoader()
        // Имитируем загрузку
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.stopLoader()
            let orderVC = OrderViewController()
            self?.navigationController?.pushViewController(orderVC, animated: true)
        }
    }
}

// MARK: - Layout
extension CartViewController {
    private func setupLayout() {
        view.backgroundColor = AppColors.backgroundWhite
        
        // Сначала добавляем все view в иерархию
        view.addSubview(topTitleLabel)
        view.addSubview(separatorLine)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(orderButton)
        view.addSubview(loaderContainer)
        
        // Затем настраиваем констрейнты
        setupTopLabel()
        setupSeparatorLine()
        setupTableView()
        setupEmptyStateLabel()
        setupTotalPriceLabel()
        setupOrderButton()
        setupLoaderView()
    }
    
    private func setupTopLabel() {
        topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            topTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -33)
        ])
    }
    
    private func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -20)
        ])
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTotalPriceLabel() {
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            totalPriceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITableViewDelegate & DataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserStorage.shared.cartOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell
        
        let food = UserStorage.shared.cartOrder[indexPath.row]
        let quantity = UserStorage.shared.cartItems[food] ?? 0
        
        cell?.configure(with: food, quantity: quantity)
        
        cell?.onQuantityChanged = { [weak self] newQuantity in
            guard self != nil else { return }
            if newQuantity > 0 {
                UserStorage.shared.cartItems[food] = newQuantity
                NotificationCenter.default.post(name: NSNotification.Name("CartDidChange"), object: nil)
            } else {
                UserStorage.shared.removeFromCart(food)
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
