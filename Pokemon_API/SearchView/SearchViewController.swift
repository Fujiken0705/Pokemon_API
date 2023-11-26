//
//  SearchViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

final class SearchViewController : UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var pokemons: [Pokemon] = [] // 全ポケモンデータ
    var filteredPokemons: [Pokemon] = [] // 検索結果

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        // カスタムセルの登録
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonCell")

        fetchAllPokemons()
    }

    func fetchAllPokemons() {
        PokeAPIClient().fetchPokemonList { [weak self] pokemons in
            guard let self = self, let pokemons = pokemons else { return }
            self.pokemons = pokemons
            self.filteredPokemons = pokemons
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
