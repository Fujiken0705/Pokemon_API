//
//  fetchPokemonList.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/25.
//


import Alamofire

struct PokeAPIClient {
    func fetchPokemonList() async throws -> [GeneralPokemonInfo] {
        //TODO:host名 スキーマとかを　Componentsで指定できるようにしよう
//        let component =  URLComponents()

        let url = "https://pokeapi.co/api/v2/pokemon?limit=151"
        let response = try await AF.request(url).serializingDecodable(PokemonListAPIResponse.self).value

        var pokemons: [GeneralPokemonInfo] = []

        // TaskGroupを使用して並列に詳細情報を取得
        try await withThrowingTaskGroup(of: GeneralPokemonInfo?.self, body: { group in
            for entry in response.results {
                group.addTask {
                    let detail = try? await self.fetchPokemonDetail(url: entry.url)
                    if let detail = detail {
                        return GeneralPokemonInfo(
                            name: entry.name,
                            url: entry.url,
                            imageUrl: detail.sprites.front_default,
                            id: detail.id,
                            height: detail.height,
                            weight: detail.weight,
                            types: detail.types.map { $0.type.name }
                        )
                    }
                    return nil
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

    func fetchPokemonDetail(url: String) async throws -> PokemonDetails? {
            try await AF.request(url).serializingDecodable(PokemonDetails.self).value
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
