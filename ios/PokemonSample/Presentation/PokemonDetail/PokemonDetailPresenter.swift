//
//  PokemonDetailPresenter.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/09.
//

import Foundation
import Combine

/// ポケモン詳細画面のPresenter
@MainActor
class PokemonDetailPresenter: ObservableObject {
    @Published private(set) var viewState: PokemonDetailViewState = .initial
    
    private let pokemonName: String
    private let getDetailInteractor: GetPokemonDetailInteractor
    private let router: AppRouter
    
    init(
        pokemonName: String,
        getDetailInteractor: GetPokemonDetailInteractor,
        router: AppRouter
    ) {
        self.pokemonName = pokemonName
        self.getDetailInteractor = getDetailInteractor
        self.router = router
    }
    
    func loadPokemonDetail() async {
        viewState = .loading
        
        let result = await getDetailInteractor.execute(pokemonName: pokemonName)
        
        switch result {
        case .success(let pokemon):
            viewState = .success(pokemon: pokemon)
        case .failure(let error):
            viewState = .error(error.localizedDescription)
        }
    }
    
    func onRetryTapped() async {
        await loadPokemonDetail()
    }
    
    func navigationBack() {
        router.pop()
    }
}
