//
//  SearchViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

final class SearchViewController : UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private var pokemons: [GeneralPokemonInfo] = [] // 全ポケモンデータ
    private var filteredPokemons: [GeneralPokemonInfo] = [] // 検索結果

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonCell")

        // 非同期タスクとしてfetchAllPokemonsを実行
        Task {
            await fetchAllPokemons()
        }
    }

    // fetchAllPokemonsをasyncメソッドに変更します
    private func fetchAllPokemons() async {
        do {
            let fetchedPokemons = try await PokeAPIClient().fetchPokemonList()
            self.pokemons = fetchedPokemons
            self.filteredPokemons = fetchedPokemons // 初期状態では全てのポケモンを表示
            tableView.reloadData()
        } catch {
            // エラーハンドリング
            print(error)
        }
    }
}

// UISearchBarDelegate methods
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemons = searchText.isEmpty ? pokemons : pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

// UITableViewDataSource methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonTableViewCell else {
            fatalError("The dequeued cell is not an instance of PokemonTableViewCell.")
        }
        let pokemon = filteredPokemons[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
}

// UITableViewDelegate methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = filteredPokemons[indexPath.row]
        let detailVC = PokemonDetailViewController(nibName: "PokemonDetailViewController", bundle: nil)
        detailVC.pokemon = pokemon
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
