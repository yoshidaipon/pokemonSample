//
//  GetPokemonDetailInteractor.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/09.
//

import Foundation

/// ポケモン詳細取得用Interactor
class GetPokemonDetailInteractor {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(pokemonName: String) async -> Result<PokemonDetail> {
        guard !pokemonName.isEmpty else {
            return .failure(APIError.custom("Pokemon name is empty"))
        }
        
        return await repository.getPokemonDetailByName(name: pokemonName)
    }
}
