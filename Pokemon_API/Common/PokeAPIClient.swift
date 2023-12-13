//
//  fetchPokemonList.swift
//  Pokemon_API
//
//  Created by KentoFujita on 2023/11/25.
//


import Alamofire
import Foundation

struct PokeAPIClient {
    func fetchPokemonList() async throws -> [GeneralPokemonInfo] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pokeapi.co"
        components.path = "/api/v2/pokemon"
        components.queryItems = [URLQueryItem(name: "limit", value: "151")]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let response = try await AF.request(url).serializingDecodable(PokemonListAPIResponse.self).value
        return try await fetchDetailsFor(pokemonEntries: response.results)
    }

    private func fetchDetailsFor(pokemonEntries: [BasicPokemonInfo]) async throws -> [GeneralPokemonInfo] {
        try await withThrowingTaskGroup(of: GeneralPokemonInfo?.self, body: { group in
            var detailedPokemons = [GeneralPokemonInfo]()

            for entry in pokemonEntries {
                group.addTask {
                    return try await self.fetchDetailsFor(entry: entry)
                }
            }

            for try await pokemon in group {
                if let pokemon = pokemon {
                    detailedPokemons.append(pokemon)
                }
            }

            return detailedPokemons.sorted(by: { $0.id < $1.id })
        })
    }

    private func fetchDetailsFor(entry: BasicPokemonInfo) async throws -> GeneralPokemonInfo? {
        let detailsResponse = try await fetchPokemonDetail(url: entry.url)
        guard let details = detailsResponse else { return nil }

        let species = try await fetchPokemonSpecies(url: details.species.url)
        let japaneseName = species?.names.first { $0.language.name == "ja" }?.name ?? entry.name
        let japaneseTypeNames = try await fetchJapaneseTypeNames(from: details.types)

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

    private func fetchPokemonDetail(url: String) async throws -> PokemonDetails? {
        try await AF.request(url).serializingDecodable(PokemonDetails.self).value
    }

    private func fetchPokemonSpecies(url: String) async throws -> PokemonSpecies? {
        try await AF.request(url).serializingDecodable(PokemonSpecies.self).value
    }

    private func fetchJapaneseTypeNames(from types: [PokemonTypeReference]) async throws -> [String] {
        try await withThrowingTaskGroup(of: String?.self, body: { group in
            var typeNames = [String]()

            for typeInfo in types {
                group.addTask {
                    return try await self.fetchTypeName(for: typeInfo.type)
                }
            }

            for try await typeName in group {
                if let typeName = typeName {
                    typeNames.append(typeName)
                }
            }

            return typeNames
        })
    }

    private func fetchTypeName(for resourceLink: ResourceLink) async throws -> String? {
        guard let typeResponse = try await fetchPokemonType(url: resourceLink.url) else { return nil }
        return typeResponse.names.first { $0.language.name == "ja" }?.name ?? resourceLink.name
    }

    private func fetchPokemonType(url: String) async throws -> PokemonType? {
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
