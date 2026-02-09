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
