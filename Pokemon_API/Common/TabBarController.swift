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

        let searchView = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchView.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let listView = ListViewController(nibName: "ListViewController", bundle: nil)
        listView.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        let favoriteView = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
        favoriteView.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)

        viewControllers = [searchView, listView, favoriteView]

        selectedIndex = 1
    }
}
