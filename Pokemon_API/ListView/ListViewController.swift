//
//  ListViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit
import Dispatch
import AlamofireImage

final class ListViewController: UIViewController {

    @IBOutlet weak var pokemonCollectionView: UICollectionView!

    var pokemons: [Pokemon] = [] // ポケモンデータの配列

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchPokemons()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // セクションの周囲のスペース
        layout.minimumLineSpacing = 10 // セルの行間の最小スペーシング
        layout.minimumInteritemSpacing = 10 // セル間の最小スペーシング

        pokemonCollectionView.collectionViewLayout = layout
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        pokemonCollectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCell")
    }

    private func fetchPokemons() {
        PokeAPIClient().fetchPokemonList { [weak self] pokemons in
            guard let self = self else { return }
            guard let pokemons = pokemons else {
                // エラーハンドリング
                return
            }

            self.pokemons = pokemons
            self.fetchPokemonImages()
        }
    }

    private func fetchPokemonImages() {
        let dispatchGroup = DispatchGroup()

        pokemons.enumerated().forEach { (index, pokemon) in
            dispatchGroup.enter()
            PokeAPIClient().fetchPokemonDetail(url: pokemon.url) { [weak self] detail in
                guard let self = self, let imageUrl = detail?.sprites.front_default else {
                    dispatchGroup.leave()
                    return
                }
                self.pokemons[index].imageUrl = imageUrl
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.pokemonCollectionView.reloadData()
        }
    }
}

// データソースとデリゲートのメソッド
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

// デリゲートメソッドも拡張に追加します
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // セルが選択された時の処理をここに実装
    }
}

