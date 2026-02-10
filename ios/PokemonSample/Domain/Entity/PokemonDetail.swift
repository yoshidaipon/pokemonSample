//
//  PokemonDetail.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/09.
//

import Foundation

/// ポケモン詳細情報のドメインモデル
struct PokemonDetail: Equatable {
    let id: Int
    let name: String
    let height: Int //デシメートル単位
    let weight: Int //ヘクトグラム単位
    let types: [PokemonType]
    let stats: [PokemonStat]
    let abilities: [String]
    let sprites: PokemonSprites
    
    /// 名前を表示用にフォーマット
    var displayName: String {
        name.prefix(1).uppercased() + name.dropFirst()
    }
    
    /// 身長をメートル単位で取得
    var heightInMeters: String {
        String(format: "%.1f m", Double(height) / 10.0)
    }
    
    /// 体重をキログラム単位で取得
    var weightInKg: String {
        String(format: "%.1f kg", Double(weight) / 10.0)
    }
    
    /// IDをフォーマット
    var idFormatted: String {
        String(format: "#%03d", id)
    }
}

/// ポケモンのタイプ
struct PokemonType: Equatable {
    let slot: Int
    let name: String
    
    var displayName: String {
        name.prefix(1).uppercased() + name.dropFirst()
    }
}

/// ポケモンのステータス
struct PokemonStat: Equatable {
    let name: String
    let baseStat: Int
    let effort: Int
    
    var displayName: String {
        switch name {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return name.prefix(1).uppercased() + name.dropFirst()
        }
    }
    
    var percentage: Double {
        min(Double(baseStat) / 255.0, 1.0)
    }
}

/// ポケモンのスプライト画像
struct PokemonSprites: Equatable {
    let frontDefault: String?
    let frontShiny: String?
}
