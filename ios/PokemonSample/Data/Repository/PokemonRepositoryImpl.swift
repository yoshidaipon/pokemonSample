//
//  PokemonRepositoryImpl.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// ポケモンリポジトリの実装
class PokemonRepositoryImpl: PokemonRepository {
    private let apiService: PokeAPIServiceProtocol
    
    init(apiService: PokeAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getPokemonList(limit: Int, offset: Int) async -> Result<(pokemons: [Pokemon], hasMore: Bool)> {
        do {
            let response = try await apiService.getPokemonList(limit: limit, offset: offset)
            let pokemons = response.results.map { $0.toDomain() }
            let hasMore = response.next != nil
            return .success((pokemons: pokemons, hasMore: hasMore))
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(APIError.networkError)
        }
    }
}
