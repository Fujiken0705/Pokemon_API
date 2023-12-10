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
        setupCellStyle()
    }

    private func setupCellStyle() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }

    func configure(with pokemon: GeneralPokemonInfo) {
        pokemonNameLabel.text = pokemon.name

        guard let imageUrlString = pokemon.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            pokemonImageView.image = nil
            return
        }

        pokemonImageView.af.setImage(withURL: imageUrl)
    }
}
