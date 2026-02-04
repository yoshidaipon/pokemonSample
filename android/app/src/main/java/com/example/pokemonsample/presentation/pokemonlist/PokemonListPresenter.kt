package com.example.pokemonsample.presentation.pokemonlist

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.pokemonsample.domain.entity.Pokemon
import com.example.pokemonsample.domain.entity.Result
import com.example.pokemonsample.domain.interactor.GetPokemonListInteractor
import com.example.pokemonsample.domain.interactor.SearchPokemonInteractor
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.launch
import okhttp3.Route
import javax.inject.Inject

/**
 * ポケモン一覧画面のPresenter
 * ViewModelを継承し、Interactorを呼び出してViewStateを更新
 */
@HiltViewModel
class PokemonListPresenter @Inject constructor(
    private val getPokemonListInteractor: GetPokemonListInteractor,
    private val searchPokemonInteractor: SearchPokemonInteractor,
    val router: PokemonListRouter
) : ViewModel() {
    private val _viewState = MutableStateFlow<PokemonListViewState>(PokemonListViewState.Initial)
    val viewState: StateFlow<PokemonListViewState> = _viewState.asStateFlow()
    private val _searchQuery = MutableStateFlow("")
    private val limit = 20 //ページサイズ

    init {
        // 初期データ読み込み
        loadPokemonList()

        // 検索クエリの変更を監視（デバウンス付き）
        setupSearchObserver()
    }

    /**
     * ポケモン一覧を読み込み
     */
    fun loadPokemonList() {
        viewModelScope.launch {
            _viewState.value = PokemonListViewState.Loading

            val result = getPokemonListInteractor()

            _viewState.value = when (result) {
                is Result.Success -> {
                    val viewDataList = result.data.map { PokemonViewData.from(it) }
                    PokemonListViewState.Success(
                        pokemonList = viewDataList,
                        isSearching = false,
                        searchQuery = ""
                    )
                }
                is Result.Error -> {
                    PokemonListViewState.Error(
                        message = result.message ?: "エラーが発生しました"
                    )
                }
                is Result.Loading -> PokemonListViewState.Loading
            }
        }
    }

    /**
     * 検索クエリが変更された際の処理
     */
    fun onSearchQueryChanged(query: String) {
        _searchQuery.value = query
    }

    /**
     * 検索実行
     */
    private fun performSearch(query: String) {

    }

    /**
     * 検索クエリの監視をセットアップ
     * 300ms のデバウンスを適用
     */
    @OptIn(FlowPreview::class)
    private fun setupSearchObserver() {
        viewModelScope.launch {
            _searchQuery
                .debounce { 300 } // 300ms待ってから実行
                .distinctUntilChanged() // 値が変わった時のみ
                .collect { query ->
                    performSearch(query)
                }
        }

    }

    /**
     * ポケモンカードがクリックされた際の処理
     */
    fun onPokemonClicked(pokemonId: Int) {

    }

    /**
     * リフレッシュ
     */
    fun onRefresh() {
        loadPokemonList()
    }

    /**
     * 次のページを読み込み（無限スクロール用）
     */
    fun loadMorePokemon() {
        val currentState = _viewState.value
        if (currentState !is PokemonListViewState.Success ||
            currentState.isLoadingMore ||
            !currentState.hasMore ||
            currentState.searchQuery.isNotEmpty()) {
            return
        }

        viewModelScope.launch {
            _viewState.value = currentState.copy(isLoadingMore = true)

            val result = getPokemonListInteractor(
                limit = limit,
                offset = currentState.pokemonList.size
            )

            _viewState.value = when (result) {
                is Result.Success -> {
                    val newList = currentState.pokemonList + result.data.map { PokemonViewData.from(it) }
                    currentState.copy(
                        pokemonList = newList,
                        isLoadingMore = false,
                        hasMore = result.data.size == limit
                    )
                }
                is Result.Error -> {
                    currentState.copy(isLoadingMore = false)
                }
                is Result.Loading -> currentState
            }
        }
    }
}
