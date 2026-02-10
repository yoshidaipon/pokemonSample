//
//  PokemonResponse.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// ポケモンAPI からのポケモン一覧レスポンス
struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResponse]
}

/// ポケモンの基本情報レスポンス
struct PokemonResponse: Codable {
    let name: String
    let url: String
    
    /// URL からポケモンのIDを抽出
    var id: Int {
        let components = url.split(separator: "/")
        return Int(components[components.count - 1]) ?? 0
    }
}

/// ポケモンの詳細情報レスポンス
struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeSlot]
    let stats: [StatResponse]
    let abilities: [AbilitySlot]
    let sprites: SpritesResponse
}

struct TypeSlot: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}

struct StatResponse: Codable {
    let baseStat: Int
    let effort: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct StatInfo: Codable {
    let name: String
    let url: String
}

struct AbilitySlot: Codable {
    let isHidden: Bool
    let slot: Int
    let ability: AbilityInfo
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot
        case ability
    }
}

struct AbilityInfo: Codable {
    let name: String
    let url: String
}

struct SpritesResponse: Codable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
