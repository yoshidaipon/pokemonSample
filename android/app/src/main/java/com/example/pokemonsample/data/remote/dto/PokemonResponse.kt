package com.example.pokemonsample.data.remote.dto

import android.hardware.biometrics.BiometricManager
import com.google.gson.annotations.SerializedName

/**
 * PokeAPI からのポケモン一覧レスポンス
 */
data class PokemonListResponse(
    @SerializedName("count")
    val count: Int,
    @SerializedName("next")
    val next: String?,
    @SerializedName("previous")
    val previous: String?,
    @SerializedName("results")
    val results: List<PokemonResponse>
)

/**
 * ポケモンの基本情報レスポンス
 */
data class PokemonResponse(
    @SerializedName("name")
    val name: String,
    @SerializedName("url")
    val url: String
) {
    /**
     * URLからポケモンIDを抽出
     * 例: https://pokeapi.co/api/v2/pokemon/1/ -> 1
     */
    val id: Int
        get() = url.trimEnd('/').split('/').last().toInt()
}