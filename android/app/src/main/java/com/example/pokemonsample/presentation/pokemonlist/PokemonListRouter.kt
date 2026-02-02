package com.example.pokemonsample.presentation.pokemonlist

import androidx.navigation.NavHostController
import javax.inject.Inject

/**
 * ポケモン一覧画面のRouter
 * ナビゲーションロジックを担当
 */
class PokemonListRouter @Inject constructor() {

    private var navController: NavHostController? = null

    fun setNavController(navController: NavHostController) {
        this.navController = navController
    }

    fun navigateToPokemonDetails(pokemonId: Int) {
        navController?.navigate("pokemon_details/$pokemonId")
    }
}