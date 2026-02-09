//
//  PokemonListPresenter.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation
import Combine

/// ポケモン一覧画面のPresenter
@MainActor
class PokemonListPresenter: ObservableObject {
    @Published private(set) var viewState: PokemonListViewState = .initial
    @Published var searchQuery: String = ""
    
    private let getPokemonListInteractor: GetPokemonListInteractor
    private let router: AppRouter
    
    private var currentOffset = 0
    private let pageSize = 20
    private var isSearching = false
    private var searchTask: Task<Void, Never>?
    
    init(
        getPokemonListInteractor: GetPokemonListInteractor,
        router: AppRouter
    ) {
        self.getPokemonListInteractor = getPokemonListInteractor
        self.router = router
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadInitialData() async {
        viewState = .loading
        currentOffset = 0
        isSearching = false
        
        let result = await getPokemonListInteractor.execute(limit: pageSize, offset: currentOffset)
        
        switch result {
        case .success(let data):
            viewState = .success(pokemons: data.pokemons, hasMore: data.hasMore, isLoadingMore: false)
            currentOffset += pageSize
        case .failure(let error):
            viewState = .error(error.localizedDescription)
        }
    }
    
    func loadMorePokemons() async {
        guard case .success(let pokemons, let hasMore, _) = viewState,
              hasMore,
              !isSearching else {
            return
        }
        
        // isLoadingMoreをtrueに設定
        viewState = .success(pokemons: pokemons, hasMore: hasMore, isLoadingMore: true)
        
        let result = await getPokemonListInteractor.execute(limit: pageSize, offset: currentOffset)
        
        switch result {
        case .success(let data):
            viewState = .success(
                pokemons: pokemons + data.pokemons,
                hasMore: data.hasMore,
                isLoadingMore: false
            )
            currentOffset += pageSize
        case .failure:
            // エラー時は読み込み状態を解除
            viewState = .success(
                pokemons: pokemons,
                hasMore: hasMore,
                isLoadingMore: false
            )
        }
    }
    
    func onPokemonTapped(_ pokemon: Pokemon) {
        
    }
    
    func onRetryTapped() async {
        await loadInitialData()
    }
}
