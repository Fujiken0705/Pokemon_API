//
//  ListViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit
import AlamofireImage

final class ListViewController: UIViewController {

    @IBOutlet private weak var pokemonCollectionView: UICollectionView!

    var pokemons: [GeneralPokemonInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        Task {
            await fetchPokemons()
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        pokemonCollectionView.collectionViewLayout = layout
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        pokemonCollectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCell")
    }

    private func fetchPokemons() async {
        do {
            let fetchedPokemons = try await PokeAPIClient().fetchPokemonList()
            self.pokemons = fetchedPokemons
            pokemonCollectionView.reloadData()
        } catch {
            print(error)
        }
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCollectionViewCell else {
            fatalError("Unable to dequeue PokemonCell")
        }
        let pokemon = pokemons[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = pokemons[indexPath.row]
        let detailVC = PokemonDetailViewController(nibName: "PokemonDetailViewController", bundle: nil)
        detailVC.pokemon = pokemon
        self.present(detailVC, animated: true, completion: nil)
    }
}
