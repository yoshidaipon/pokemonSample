//
//  PokemonRepository.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// ポケモンデータのリポジトリインターフェース
protocol PokemonRepository {
    func getPokemonList(limit: Int, offset: Int) async -> Result<(pokemons: [Pokemon], hasMore: Bool)>
    func getPokemonDetail(id: Int) async -> Result<PokemonDetail>
    func getPokemonDetailByName(name: String) async -> Result<PokemonDetail>
}
