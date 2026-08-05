//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Marcos Morales on 04/08/26.
//

import Foundation

// MARK: - PokemonSpecies
struct PokemonSpecies: Codable {
    let color: NamedAPIResource
    let evolutionChain: APIResource
    let genera: [Genus]
    let generation: NamedAPIResource
    let id: Int
    let isBaby: Bool
    let isLegendary: Bool
    let isMythical: Bool
    let name: String
    let names: [Name]
    let varieties: [Variety]
}


// MARK: - Genus
struct Genus: Codable {
    let genus: String
    let language: NamedAPIResource
}

// MARK: - Name
struct Name: Codable {
    let language: NamedAPIResource
    let name: String
}


// MARK: - Variety
struct Variety: Codable {
    let isDefault: Bool
    let pokemon: NamedAPIResource
}

