package com.example.pokemonsample.data.repository

import com.example.pokemonsample.data.remote.api.PokeApiService
import com.example.pokemonsample.domain.entity.Pokemon
import com.example.pokemonsample.domain.entity.Result
import com.example.pokemonsample.domain.repository.PokemonRepository
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
        return Result.Success(emptyList())
    }

    override suspend fun searchPokemon(query: String): Result<List<Pokemon>> {
        // とりあえず空リストを返す
        return Result.Success(emptyList())
    }
}
