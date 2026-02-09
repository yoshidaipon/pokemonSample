//
//  DependencyContainer.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// 依存関係コンテナ
class DependencyContainer {
    
    // MARK: - Data Layer
    
    private lazy var apiService: PokeAPIServiceProtocol = {
        PokeAPIService()
    }()
    
    private lazy var pokemonRepository: PokemonRepository = {
        PokemonRepositoryImpl(apiService: apiService)
    }()
    
    // MARK: - Domain Layer (Interactors)
    
    private lazy var getPokemonListInteractor: GetPokemonListInteractor = {
        GetPokemonListInteractor(repository: pokemonRepository)
    }()
        
    // MARK: - Presenter Factory
    
    func makePokemonListPresenteer(router: AppRouter) -> PokemonListPresenter {
        PokemonListPresenter(
            getPokemonListInteractor: getPokemonListInteractor,
            router: router
        )
    }
}
