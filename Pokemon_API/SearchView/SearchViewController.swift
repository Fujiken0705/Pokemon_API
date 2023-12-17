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

    private var pokemons: [GeneralPokemonInfo] = []
    private var filteredPokemons: [GeneralPokemonInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonCell")

        Task {
            await fetchAllPokemons()
        }
    }

    private func fetchAllPokemons() async {
        do {
            let fetchedPokemons = try await PokeAPIClient().fetchPokemonList()
            self.pokemons = fetchedPokemons
            self.filteredPokemons = fetchedPokemons
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemons = searchText.isEmpty ? pokemons : pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
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
