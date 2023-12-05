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
}
