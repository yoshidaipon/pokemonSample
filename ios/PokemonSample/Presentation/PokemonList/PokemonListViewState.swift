//
//  PokemonListViewState.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// ポケモン一覧画面のViewState
enum PokemonListViewState: Equatable {
    case initial
    case loading
    case success(pokemons: [Pokemon], hasMore: Bool, isLoadingMore: Bool)
    case error(String)
    
    static func == (lhs: PokemonListViewState, rhs: PokemonListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.success(let lPokemons, let lHasMore, let lIsLoadingMore),
              .success(let rPokemons, let rHasMore, let rIsLoadingMore)):
            return lPokemons == rPokemons && lHasMore == rHasMore && lIsLoadingMore == rIsLoadingMore
        case (.error(let lMessage), .error(let rMessage)):
            return lMessage == rMessage
        default:
            return false
        }
    }
}
