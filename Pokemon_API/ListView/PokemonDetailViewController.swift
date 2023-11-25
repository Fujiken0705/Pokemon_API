//
//  PokemonDetailViewController.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/25.
//

import  UIKit

final class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var DetailImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet weak var pokemonHeightLabel: UILabel!
    @IBOutlet weak var pokemonWeightLabel: UILabel!
    @IBOutlet weak var pokemonFavoriteButton: UIButton!

    var pokemon: Pokemon? //詳細画面に表示するポケモンを指定するためにプロパティを定義

    override func viewDidLoad() {
        super.viewDidLoad()

        if let pokemon = pokemon {
            pokemonNameLabel.text = "Name: \(pokemon.name)"

            // タイプが複数あるかどうかをチェック
            if pokemon.types.count > 1 {
                pokemonTypeLabel.text = "Types: " + pokemon.types.joined(separator: ", ")
            } else if pokemon.types.count == 1 {
                pokemonTypeLabel.text = "Type: " + pokemon.types.first!
            } else {
                pokemonTypeLabel.text = "Type: Unknown"
            }

            // 単位変換を行い、ポケモンの高さと重さを設定
            pokemonHeightLabel.text = "Height: \(Double(pokemon.height) / 10.0) m"
            pokemonWeightLabel.text = "Weight: \(Double(pokemon.weight) / 10.0) kg"

            if let imageUrlString = pokemon.imageUrl, let imageUrl = URL(string: imageUrlString) {
                DetailImageView.af.setImage(withURL: imageUrl)
            }
        }
    }

}