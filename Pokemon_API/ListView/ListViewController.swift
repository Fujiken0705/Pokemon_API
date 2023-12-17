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

    private var pokemons: [GeneralPokemonInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadPokemons()
    }

    private func configureCollectionView() {
        let layout = createFlowLayout()
        pokemonCollectionView.collectionViewLayout = layout
        pokemonCollectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCell")
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
    }

    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }

    private func loadPokemons() {
        Task {
            do {
                pokemons = try await PokeAPIClient().fetchPokemonList()
                pokemonCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeuePokemonCell(for: indexPath)
        cell.configure(with: pokemons[indexPath.row])
        return cell
    }

    private func dequeuePokemonCell(for indexPath: IndexPath) -> PokemonCollectionViewCell {
        guard let cell = pokemonCollectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCollectionViewCell else {
            fatalError("Unable to dequeue PokemonCell")
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailViewController(for: pokemons[indexPath.row])
    }

    private func presentDetailViewController(for pokemon: GeneralPokemonInfo) {
        let detailViewController = PokemonDetailViewController(nibName: "PokemonDetailViewController", bundle: nil)
        detailViewController.pokemon = pokemon
        present(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 画面の幅を取得
        let width = collectionView.bounds.width
        // セルの間隔
        let padding: CGFloat = 10
        // 一行に表示するセルの数
        let itemsPerRow: CGFloat = 2
        // セルの幅を計算
        let availableWidth = width - (padding * (itemsPerRow + 1))
        let widthPerItem = availableWidth / itemsPerRow
        // 正方形のセルを作成するために、幅と高さを同じにする
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
