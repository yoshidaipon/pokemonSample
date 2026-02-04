package com.example.pokemonsample.data.mapper

import com.example.pokemonsample.data.remote.dto.PokemonResponse
import com.example.pokemonsample.domain.entity.Pokemon

/**
 * DTOからDomainモデルへの変換
 */
fun PokemonResponse.toDomain(): Pokemon {
    return Pokemon(
        id = this.id,
        name = this.name,
        url = this.url
    )
}