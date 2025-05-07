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
    private let topTitleLabel: UILabel = {
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
    
    private let emptyStateLabel: UILabel = {
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
        return table
    }()
    
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
            }
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = UserStorage.shared.cartOrder.isEmpty
        
        UIView.animate(withDuration: 0.3) {
            self.emptyStateLabel.alpha = isEmpty ? 1.0 : 0.0
            self.emptyStateLabel.isHidden = !isEmpty
        }
    }
}

// MARK: - Layout
extension CartViewController {
    private func setupLayout() {
        view.backgroundColor = AppColors.backgroundWhite
        setupTopLabel()
        setupSeparatorLine()
        setupTableView()
        setupEmptyStateLabel()
    }
    
    private func setupTopLabel() {
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            guard let self = self else { return }
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
