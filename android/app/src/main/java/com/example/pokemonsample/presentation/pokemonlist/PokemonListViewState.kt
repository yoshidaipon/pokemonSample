package com.example.pokemonsample.presentation.pokemonlist

import com.example.pokemonsample.domain.entity.Pokemon

/**
 * ポケモン一覧画面のViewState
 * sealed interface で状態を定義
 */
sealed interface PokemonListViewState {
    /**
     * 初期状態
     */
    object Initial : PokemonListViewState

    /**
     * ローディング中
     */
    object  Loading : PokemonListViewState

    /**
     * 成功（データ取得完了）
     */
    data class Success(
        val pokemonList: List<PokemonViewData>,
        val isSearching: Boolean = false,
        val searchQuery: String = "",
        val isLoadingMore: Boolean = false, //ページング用
        val hasMore: Boolean = true //さらにデータがあるか
    ) : PokemonListViewState

    /**
     * エラー
     */
    data class Error(
        val message: String
    ) : PokemonListViewState
}

/**
 * ポケモンのView表示用データ
 * Entity から変換されたプレゼンテーション層モデル
 */
data class PokemonViewData(
    val id: Int,
    val name: String,
    val displayName: String,
    val imageUrl: String,
    val idFormatted: String // "#001" のようなフォーマット
) {
    companion object {
        /**
         * Domain の Pokemon から ViewData に変換
         */
        fun from(pokemon: Pokemon): PokemonViewData {
            return PokemonViewData(
                id = pokemon.id,
                name = pokemon.name,
                displayName = pokemon.displayName,
                imageUrl = pokemon.imageUrl,
                idFormatted = "#${pokemon.id.toString().padStart(3, '0')}"
            )
        }
    }
}