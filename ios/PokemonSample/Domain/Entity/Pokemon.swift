//
//  Pokemon.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/04.
//
import Foundation

/// ポケモンのドメインモデル（一覧表示用）
struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let url: String
    
    /// 画像URLを取得
    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
    
    /// 名前を表示用にフォーマット
    var displayName: String {
        name.prefix(1).uppercased() + name.dropFirst()
    }
    
    /// IDをフォーマット（#001の形式）
    var idFormatted: String {
        String(format: "#%03d", id)
    }
}
