package com.example.pokemonsample.presentation.pokemonlist
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.layout.ContentScale
import androidx.hilt.navigation.compose.hiltViewModel

/**
 * ポケモン一覧画面のView
 * Jetpack Compose による宣言的UI
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PokemonListScreen(presenter: PokemonListPresenter = hiltViewModel()) {
    Scaffold() { }
}