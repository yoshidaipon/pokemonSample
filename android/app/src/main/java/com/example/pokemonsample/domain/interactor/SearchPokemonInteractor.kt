package com.example.pokemonsample.domain.interactor

import com.example.pokemonsample.domain.entity.Pokemon
import com.example.pokemonsample.domain.entity.Result
import com.example.pokemonsample.domain.repository.PokemonRepository
import javax.inject.Inject

/**
 * ポケモン検索のInteractor (UseCase)
 */
class SearchPokemonInteractor @Inject constructor(
    private val repository: PokemonRepository
) {
    /**
     * ポケモンを名前またはIDで検索
     * @param query 検索クエリ（空文字の場合は全件取得）
     * @return 検索結果
     */
    suspend operator fun invoke(query: String): Result<List<Pokemon>> {
        // クエリの正規化
        val normalizedQuery = query.trim().lowercase()

        // Repositoryから検索実行
        return repository.searchPokemon(normalizedQuery)
    }
}