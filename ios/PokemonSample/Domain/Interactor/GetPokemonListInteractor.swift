//
//  GetPokemonListInteractor.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// ポケモン一覧を取得するInteractor
class GetPokemonListInteractor {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int = 20, offset: Int = 0) async -> Result<(pokemons: [Pokemon], hasMore: Bool)> {
        guard limit > 0, offset >= 0 else {
            return .failure(APIError.custom("Invalid parameters"))
        }
        return await repository.getPokemonList(limit: limit, offset: offset)
    }
}
