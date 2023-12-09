//
//  fetchPokemonList.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/25.
//


import Alamofire

struct PokeAPIClient {
    func fetchPokemonList() async throws -> [GeneralPokemonInfo] {
        let url = "https://pokeapi.co/api/v2/pokemon?limit=151"
        let response = try await AF.request(url).serializingDecodable(PokemonListAPIResponse.self).value

        var pokemons: [GeneralPokemonInfo] = []

        try await withThrowingTaskGroup(of: GeneralPokemonInfo?.self, body: { group in
            for entry in response.results {
                group.addTask {
                    let detailsResponse = try? await self.fetchPokemonDetail(url: entry.url)
                    guard let details = detailsResponse?.details,
                          let speciesUrl = detailsResponse?.speciesUrl else {
                        return nil
                    }

                    let speciesResponse = try? await self.fetchPokemonSpecies(url: speciesUrl)
                    let japaneseName = speciesResponse?.names.first { $0.language.name == "ja" }?.name ?? entry.name

                    var japaneseTypeNames: [String] = []
                    for typeInfo in details.types {
                        if let typeResponse = try? await self.fetchPokemonType(url: typeInfo.type.url),
                           let japaneseTypeName = typeResponse.names.first(where: { $0.language.name == "ja" })?.name {
                            japaneseTypeNames.append(japaneseTypeName)
                        } else {
                            japaneseTypeNames.append(typeInfo.type.name)
                        }
                    }

                    return GeneralPokemonInfo(
                        name: japaneseName,
                        url: entry.url,
                        imageUrl: details.sprites.front_default,
                        id: details.id,
                        height: details.height,
                        weight: details.weight,
                        types: japaneseTypeNames
                    )
                }
            }
            for try await pokemon in group {
                if let pokemon = pokemon {
                    pokemons.append(pokemon)
                }
            }
        })

        return pokemons.sorted { $0.id < $1.id }
    }

    func fetchPokemonDetail(url: String) async throws -> (details: PokemonDetails, speciesUrl: String)? {
        let details = try await AF.request(url).serializingDecodable(PokemonDetails.self).value
        return (details, details.species.url)
    }

    func fetchPokemonSpecies(url: String) async throws -> PokemonSpecies? {
        try await AF.request(url).serializingDecodable(PokemonSpecies.self).value
    }

    func fetchPokemonType(url: String) async throws -> PokemonType? {
        try await AF.request(url).serializingDecodable(PokemonType.self).value
    }
}

// ポケモンのリストレスポンスをデコードするために使用される構造体
// APIからのポケモンの一覧応答を扱うための構造体

// 応答全体
struct PokemonListAPIResponse: Codable {
    let results: [BasicPokemonInfo]
}

// 応答内の個々のポケモンの基本情報
struct BasicPokemonInfo: Codable {
    let name: String
    let url: String
}

// 個々のポケモンの詳細情報を扱うための構造体
struct PokemonDetails: Codable {
    let sprites: PokemonSprites
    let id: Int
    let height: Int
    let weight: Int
    let types: [PokemonTypeReference]
    let species: ResourceLink
}

struct PokemonSprites: Codable {
    let front_default: String?
}

struct PokemonTypeReference: Codable {
    let slot: Int
    let type: ResourceLink
}

struct ResourceLink: Codable {
    let name: String
    let url: String
}

// ポケモンを表す構造体
struct GeneralPokemonInfo: Codable {
    let name: String
    let url: String
    var imageUrl: String?
    let id: Int
    let height: Int
    let weight: Int
    let types: [String]
}


//以下二つはポケモンの名前を日本語に変える際に使用する構造体
struct PokemonNames: Codable {
    let language: ResourceLink
    let name: String
}

struct PokemonSpecies: Codable {
    let names: [PokemonNames]
}

//タイプの日本語名を取得するための構造体
struct PokemonTypeNames: Codable {
    let language: ResourceLink
    let name: String
}

struct PokemonType: Codable {
    let names: [PokemonTypeNames]
}


//TODO:host名 スキーマとかを　Componentsで指定できるようにしよう
//        let component =  URLComponents()
