//
//  AppRouter.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import SwiftUI
import Combine

/// ナビゲーションの宛先を定義
enum NavigationDestination: Hashable {
    case pokemonDetail(pokemonName: String)
}

/// アプリ全体のRouterクラス
@MainActor
class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateToPokemonDetail(pokemonName: String) {
        path.append(NavigationDestination.pokemonDetail(pokemonName: pokemonName))
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
