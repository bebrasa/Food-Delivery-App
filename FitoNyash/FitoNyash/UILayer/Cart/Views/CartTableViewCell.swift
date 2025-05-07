import UIKit

class CartTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var onQuantityChanged: ((Int) -> Void)?
    private var currentFood: FoodList?
    private var currentQuantity: Int = 0
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.bigHorizontalGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Roboto.bold.size(of: 14)
        label.textColor = AppColors.labelBlack
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .Roboto.regular.size(of: 18)
        label.textColor = AppColors.labelBlack
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .Roboto.regular.size(of: 14)
        label.textColor = AppColors.labelBlack.withAlphaComponent(0.5)
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "minus.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = AppColors.accentGreen
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = AppColors.accentGreen
        return button
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupProductImageView()
        setupTitleLabel()
        setupPriceLabel()
        setupQuantityLabel()
        setupMinusButton()
        setupPlusButton()
        
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupProductImageView() {
        containerView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupPriceLabel() {
        containerView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15)
        ])
    }
    
    private func setupQuantityLabel() {
        containerView.addSubview(quantityLabel)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            quantityLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupMinusButton() {
        containerView.addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            minusButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupPlusButton() {
        containerView.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 10)
        ])
    }
    
    // MARK: - Actions
    @objc private func minusButtonTapped() {
        if currentQuantity > 1 {
            currentQuantity -= 1
            updateQuantity()
        } else {
            currentQuantity = 0
            onQuantityChanged?(0)
        }
    }
    
    @objc private func plusButtonTapped() {
        currentQuantity += 1
        updateQuantity()
    }
    
    private func updateQuantity() {
        quantityLabel.text = "\(currentQuantity) шт"
        onQuantityChanged?(currentQuantity)
    }
    
    // MARK: - Configuration
    func configure(with food: FoodList, quantity: Int) {
        currentFood = food
        currentQuantity = quantity
        
        titleLabel.text = food.rawValue
        quantityLabel.text = "\(quantity) шт"
        
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
        priceLabel.text = "\(price) ₽"
        
        // TODO: Add image configuration
        productImageView.image = UIImage(resource: .cereal)
    }
} 
