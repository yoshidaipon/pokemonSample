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
