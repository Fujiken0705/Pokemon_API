//
//  fetchPokemonList.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/25.
//


import Alamofire
import Dispatch

class PokeAPIClient {
    func fetchPokemonList(completion: @escaping ([Pokemon]?) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon?limit=151"
        AF.request(url).responseDecodable(of: PokemonListResponse.self) { response in
            switch response.result {
            case .success(let listResponse):
                let pokemonEntries = listResponse.results
                var pokemons: [Pokemon] = []
                let group = DispatchGroup()

                pokemonEntries.forEach { entry in
                    group.enter()
                    self.fetchPokemonDetail(url: entry.url) { detail in
                        if let detail = detail {
                            var pokemon = Pokemon(name: entry.name, url: entry.url, id: detail.id, height: detail.height, weight: detail.weight, types: detail.types.map { $0.type.name })
                            pokemon.imageUrl = detail.sprites.front_default
                            pokemons.append(pokemon)
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    let sortedPokemons = pokemons.sorted { $0.id < $1.id }
                    completion(sortedPokemons)
                }

            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }

    func fetchPokemonDetail(url: String, completion: @escaping (PokemonDetail?) -> Void) {
        AF.request(url).responseDecodable(of: PokemonDetail.self) { response in
            switch response.result {
            case .success(let pokemonDetail):
                completion(pokemonDetail)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}

//ポケモンのリストレスポンスをデコードするために使用される構造体
struct PokemonListResponse: Codable {
    let results: [PokemonEntry]
}

struct PokemonEntry: Codable {
    let name: String
    let url: String
}

// ポケモンの詳細情報を格納する構造体
struct PokemonDetail: Codable {
    let sprites: Sprites
    let id: Int
    let height: Int
    let weight: Int
    let types: [PokemonTypeEntry]
}

struct Sprites: Codable {
    let front_default: String?
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: NamedAPIResource
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

// ポケモンを表す構造体
struct Pokemon: Codable {
    let name: String
    let url: String
    var imageUrl: String?
    let id: Int
    let height: Int
    let weight: Int
    let types: [String] // タイプの名前のみを格納する配列
}
