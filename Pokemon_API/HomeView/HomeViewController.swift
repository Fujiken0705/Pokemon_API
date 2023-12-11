//
//  HomeViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

final class HomeViewController : UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            startButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }

    @IBAction private func showTabBar(_ sender: Any) {
        let mainTabBarController = MainTabBarController()
        navigationController?.pushViewController(mainTabBarController, animated: true)
    }

    
}
