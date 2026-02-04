package com.example.pokemonsample.data.remote.api

import androidx.compose.ui.geometry.Offset
import com.example.pokemonsample.data.remote.dto.PokemonListResponse
import retrofit2.http.GET
import retrofit2.http.Query

/**
 * PokeAPI の Retrofit サービス
 * https://pokeapi.co/docs/v2
 */
interface PokeApiService {
    /**
     * ポケモン一覧を取得
     * @param limit 取得件数（デフォルト: 20）
     * @param offset オフセット（デフォルト: 0）
     */
    @GET("pokemon")
    suspend fun getPokemonList(
        @Query("limit") limit: Int = 151, // 第一世代のポケモン数
        @Query("offset") offset: Int = 0
    ): PokemonListResponse
}