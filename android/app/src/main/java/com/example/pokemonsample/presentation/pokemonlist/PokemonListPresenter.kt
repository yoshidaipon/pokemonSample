package com.example.pokemonsample.presentation.pokemonlist

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.pokemonsample.domain.interactor.GetPokemonListInteractor
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * ポケモン一覧画面のPresenter
 * ViewModelを継承し、Interactorを呼び出してViewStateを更新
 */
@HiltViewModel
class PokemonListPresenter @Inject constructor(
    private val getPokemonListInteractor: GetPokemonListInteractor,
    //private val searchPokemonInteractor: SearchPokemonInteractor,
    val router: PokemonListRouter
) : ViewModel() {
    private val _viewState = MutableStateFlow<PokemonListViewState>(PokemonListViewState.Initial)
    val viewState: StateFlow<PokemonListViewState> = _viewState.asStateFlow()
    private val _searchQuery = MutableStateFlow("")
    private val limit = 20 //ページサイズ

    init {

    }
}