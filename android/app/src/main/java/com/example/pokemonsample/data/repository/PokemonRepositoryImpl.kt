package com.example.pokemonsample.data.repository

import com.example.pokemonsample.data.mapper.toDomain
import com.example.pokemonsample.data.remote.api.PokeApiService
import com.example.pokemonsample.domain.entity.Pokemon
import com.example.pokemonsample.domain.entity.Result
import com.example.pokemonsample.domain.repository.PokemonRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.Dispatcher
import okio.IOException
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
        return withContext(Dispatchers.IO) {
            try {
                val response = apiService.getPokemonList(limit, offset)
                val pokemonList = response.results.map { it.toDomain() }
                Result.Success(pokemonList)
            } catch (e: IOException) {
                Result.Error(
                    exception = e,
                    message = "ネットワークエラーが発生しました"
                )
            } catch (e: Exception) {
                Result.Error(
                    exception = e,
                    message = "予期しないエラーが発生しました"
                )
            }
        }
    }

    override suspend fun searchPokemon(query: String): Result<List<Pokemon>> {
        // とりあえず空リストを返す
        return Result.Success(emptyList())
    }
}
