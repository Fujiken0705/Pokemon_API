//
//  PokemonCollectionViewCell.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var pokemonNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellStyle()
    }

    private func configureCellStyle() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }

    func configure(with pokemon: GeneralPokemonInfo) {
        pokemonNameLabel.text = pokemon.name
        if let imageUrl = URL(string: pokemon.imageUrl ?? "") {
            pokemonImageView.af.setImage(withURL: imageUrl)
        } else {
            pokemonImageView.image = nil
        }
    }
}
