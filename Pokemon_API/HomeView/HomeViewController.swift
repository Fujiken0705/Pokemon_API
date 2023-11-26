//
//  HomeViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

final class HomeViewController : UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func showListViewController(_ sender: Any) {
        //SearchViewControllerのインスタンスを作成
        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    
}
