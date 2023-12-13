//
//  TabBarController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/30.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchViewController.tabBarItem = UITabBarItem(title: "検索", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let listViewController = ListViewController(nibName: "ListViewController", bundle: nil)
        listViewController.tabBarItem = UITabBarItem(title: "一覧", image: UIImage(systemName: "list.bullet"), tag: 1)

        let favoriteViewController = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
        favoriteViewController.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "star.fill"), tag: 2)

        viewControllers = [searchViewController, listViewController, favoriteViewController]

        selectedIndex = 1
    }
}

