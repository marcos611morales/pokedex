//
//  PokemonType.swift
//  Pokedex
//
//  Created by Marcos Morales on 05/08/26.
//

struct PokemonType: Codable {
    let id: Int
    let name: String
    let damageRelations: DamageRelations
    let names: [Name]
}

struct DamageRelations: Codable {
    let doubleDamageFrom: [NamedAPIResource]
    let doubleDamageTo: [NamedAPIResource]
    let halfDamageFrom: [NamedAPIResource]
    let halfDamageTo: [NamedAPIResource]
    let noDamageFrom: [NamedAPIResource]
    let noDamageTo: [NamedAPIResource]
}
