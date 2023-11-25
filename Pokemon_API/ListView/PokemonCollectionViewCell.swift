//
//  PokemonCollectionViewCell.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/24.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellStyle()
    }

    func setupCellStyle() {
        // 枠線の色
        self.layer.borderColor = UIColor.black.cgColor // 枠線の色：黒
        // 枠線の幅
        self.layer.borderWidth = 1.0 // 枠線の幅：1pt
        // セルの角の丸み
        self.layer.cornerRadius = 8.0 // 角の丸み：8pt
        self.layer.masksToBounds = true // 子ビューがビューの境界を超えないようにする
    }

    func configure(with pokemon: Pokemon) {
        pokemonNameLabel.text = pokemon.name

        guard let imageUrlString = pokemon.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            pokemonImageView.image = nil
            return
        }

        // AlamofireImageを使用して画像をダウンロードし、UIImageViewにセットする
        pokemonImageView.af.setImage(withURL: imageUrl)
    }
}
