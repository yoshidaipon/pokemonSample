package com.example.pokemonsample.presentation.navigation

/**
 * ナビゲーションルートの定義
 */
sealed class NavigationRoute(val route: String) {
    object PokemonList : NavigationRoute("pokemon_list")
    //object PokemonDetail : NavigationRoute("pokemon_detail")
}