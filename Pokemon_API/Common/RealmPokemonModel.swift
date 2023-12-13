//
//  RealmPokemonModel.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/12/07.
//

import Foundation
import RealmSwift

class RealmPokemonModel: Object {
    @Persisted var name: String = ""
    @Persisted var imageUrl: String?
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var height: Int = 0
    @Persisted var weight: Int = 0
    let types = List<String>()
}


