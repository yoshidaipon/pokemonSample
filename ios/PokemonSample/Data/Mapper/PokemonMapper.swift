//
//  PokemonMapper.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// DTOからDomainモデルへの変換
extension PokemonResponse {
    func toDomain() -> Pokemon {
        Pokemon(
            id: self.id,
            name: self.name,
            url: self.url
        )
    }
}

extension PokemonDetailResponse {
    func toDomain() -> PokemonDetail {
        PokemonDetail(
            id: self.id,
            name: self.name,
            height: self.height,
            weight: self.weight,
            types: self.types.map { typeSlot in
                PokemonType(
                    slot: typeSlot.slot,
                    name: typeSlot.type.name
                )
            },
            stats: self.stats.map { statResponse in
                PokemonStat(
                    name: statResponse.stat.name,
                    baseStat: statResponse.baseStat,
                    effort: statResponse.effort
                )
            },
            abilities: self.abilities.map { $0.ability.name },
            sprites: PokemonSprites(
                frontDefault: self.sprites.frontDefault,
                frontShiny: self.sprites.frontShiny
            )
        )
    }
}
