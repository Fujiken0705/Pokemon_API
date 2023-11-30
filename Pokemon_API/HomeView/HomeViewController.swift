//
//  HomeViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

final class HomeViewController : UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var StartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction private func showTabBar(_ sender: Any) {
        let mainTabBarController = MainTabBarController()
        navigationController?.pushViewController(mainTabBarController, animated: true)
    }

    
}
