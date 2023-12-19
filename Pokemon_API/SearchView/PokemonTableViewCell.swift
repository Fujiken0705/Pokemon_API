//
//  PokemonTableViewCell.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/26.
//

import UIKit

final class PokemonTableViewCell: UITableViewCell {

    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var pokemonLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        pokemonImageView.contentMode = .scaleAspectFit // 画像がセル内で適切に表示されるように設定
        pokemonImageView.clipsToBounds = true
    }

    func configure(with pokemon: GeneralPokemonInfo) {
        pokemonLabel.text = pokemon.name
        if let imageUrlString = pokemon.imageUrl, let imageUrl = URL(string: imageUrlString) {
            pokemonImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(named: "defaultPlaceholder"))
        }
    }
}
