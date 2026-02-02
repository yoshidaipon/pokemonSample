package com.example.pokemonsample.domain.entity

data class Pokemon(val id: Int, val name: String, val url: String) {
    /**
     * 画像URLを取得
     */
    val imageUrl: String
        get() = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png"

    /**
     * 名前を表示用にフォーマット（先頭を大文字に）
     */
    val displayName: String
        get() = name.replaceFirstChar { it.uppercase() }
}