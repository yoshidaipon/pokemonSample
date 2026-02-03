package com.example.pokemonsample.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.pokemonsample.presentation.pokemonlist.PokemonListPresenter
import com.example.pokemonsample.presentation.pokemonlist.PokemonListScreen

/**
 * アプリ全体のナビゲーション設定
 */
@Composable
fun AppNavigation(navController: NavHostController = rememberNavController()) {
    NavHost(navController = navController, startDestination = NavigationRoute.PokemonList.route) {
        // ポケモン一覧画面
        composable(route = NavigationRoute.PokemonList.route) {
            val presenter: PokemonListPresenter = hiltViewModel()
            // Routerを初期化してNavControllerを設定
            presenter.router.setNavController(navController)

            PokemonListScreen(presenter = presenter)
        }
    }

}
