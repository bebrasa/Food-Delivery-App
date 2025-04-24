//
//  OnboardingPartViewController.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 24.04.2025.
//

import UIKit

// MARK: - OnboardingPartViewController
class OnboardingPartViewController: UIViewController {
    
    // MARK: - Properties
    var imageToShow: UIImage? {
        didSet {
            imageView.image = imageToShow
        }
    }
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    // MARK: - Views
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

}


// MARK: - Layout
private extension OnboardingPartViewController {
    func setupLayout() {
        view.backgroundColor = AppColors.backgroundWhite
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .Roboto.bold.size(of: 30)
        titleLabel.textColor = AppColors.labelBlack
        descriptionLabel.font = .Roboto.regular.size(of: 14)
        descriptionLabel.textColor = AppColors.labelBlack
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 35),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 0)
        ])
    }
}
