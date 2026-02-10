//
//  PokemonDetailViewState.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/09.
//

import Foundation

/// ポケモン詳細画面のViewState
enum PokemonDetailViewState: Equatable {
    case initial
    case loading
    case success(pokemon: PokemonDetail)
    case error(String)
}

