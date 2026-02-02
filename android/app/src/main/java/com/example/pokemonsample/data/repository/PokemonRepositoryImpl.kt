package com.example.pokemonsample.data.repository

import com.example.pokemonsample.domain.entity.Pokemon
import com.example.pokemonsample.domain.repository.PokemonRepository
import org.jetbrains.annotations.ApiStatus
import javax.inject.Inject
import javax.inject.Singleton

/**
 * PokemonRepository の実装クラス
 */
@Singleton
class PokemonRepositoryImpl @Inject constructor(
    private val apiService: PokeApiService
) : PokemonRepository {
    override suspend fun getPokemonList(limit: Int, offset: Int): Result<List<Pokemon>> {
        // とりあえず空リストを返す
        return Result.success(emptyList())
    }
}