//
//  PokemonRealmService.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/12/05.
//

import Foundation
import RealmSwift

class PokemonRealmService {
    private var realm: Realm?

    init () {
        do {
            self.realm = try Realm()
        } catch {
            print("Failed to initialize Realm: \(error)")
            self.realm = nil
        }
    }

    func save(pokemon: GeneralPokemonInfo) {
        guard let realm = realm else { return }

        let realmPokemonModel = RealmPokemonModel()
        realmPokemonModel.name = pokemon.name
        realmPokemonModel.imageUrl = pokemon.imageUrl
        realmPokemonModel.id = pokemon.id
        realmPokemonModel.height = pokemon.height
        realmPokemonModel.weight = pokemon.weight
        realmPokemonModel.types.append(objectsIn: pokemon.types)

        do {
            try realm.write {
                realm.add(realmPokemonModel, update: .modified)
            }
        } catch {
            print("Error saving pokemon to Realm: \(error)")
        }
    }
}
