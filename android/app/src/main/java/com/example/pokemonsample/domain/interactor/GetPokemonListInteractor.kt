package com.example.pokemonsample.domain.interactor

import com.example.pokemonsample.domain.entity.Pokemon
import com.example.pokemonsample.domain.entity.Result
import com.example.pokemonsample.domain.repository.PokemonRepository
import javax.inject.Inject

class GetPokemonListInteractor @Inject constructor(
    private val repository: PokemonRepository
){
    /**
     * ポケモン一覧を取得
     * @param limit 取得件数 (デフォルト: 20)
     * @param offset オフセット
     * @return ポケモン一覧
     */
    suspend operator fun invoke(limit: Int = 20, offset: Int = 0): Result<List<Pokemon>> {
        // バリデーション
        if (limit <= 0) {
            return Result.Error(
                exception = IllegalArgumentException("Limit must be positive"),
                message = "取得件数は1以上である必要があります"
            )
        }

        if (offset < 0) {
            return Result.Error(
                exception = IllegalArgumentException("Offset must be non-negative"),
                message = "オフセットは0以上である必要があります"
            )
        }

        // Repositoryからデータ取得
        return repository.getPokemonList(limit, offset)
    }
}