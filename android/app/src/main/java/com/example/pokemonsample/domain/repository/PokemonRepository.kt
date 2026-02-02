package com.example.pokemonsample.domain.repository

import com.example.pokemonsample.domain.entity.Pokemon

/**
 * ポケモンデータのRepository インターフェース
 * Domain層で定義し、Data層で実装
 */
interface PokemonRepository {
    /**
     * ポケモン一覧を取得
     * @param limit 取得件数（デフォルト: 20）
     * @param offset オフセット
     * @return ポケモン一覧
     */
    suspend fun getPokemonList(limit: Int = 20, offset: Int = 0): Result<List<Pokemon>>

    /**
     * ポケモンの詳細情報を取得
     * @param id ポケモンID
     * @return ポケモン詳細
     */
    //suspend fun getPokemonDetail(id: Int): Result<PokemonDetail>

    /**
     * ポケモンを名前で検索
     * @param query 検索クエリ
     * @return 検索結果
     */
    suspend fun searchPokemon(query: String): Result<List<Pokemon>>
}