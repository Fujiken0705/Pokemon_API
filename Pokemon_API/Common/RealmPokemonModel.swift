//
//  RealmPokemonModel.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/12/07.
//

import Foundation
import RealmSwift

class RealmPokemonModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var imageUrl: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var weight: Int = 0
    let types = List<String>()

    override static func primaryKey() -> String? {
        return "id"
    }
}


