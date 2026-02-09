//
//  PokemonSampleApp.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/04.
//

import SwiftUI

@main
struct PokemonSampleApp: App {
    @StateObject private var appRouter = AppRouter()
    private let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appRouter.path) {
                PokemonListView(
                    presenter: container.makePokemonListPresenteer(router: appRouter)
                )
            }
        }
    }
}
