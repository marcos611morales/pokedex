//
//  EvolutionChain.swift
//  Pokedex
//
//  Created by Marcos Morales on 05/08/26.
//

struct EvolutionChain: Codable {
    let id: Int
    let chain: ChainLink
    let babyTriggerItem: NamedAPIResource?
}

struct ChainLink: Codable {
    let isBaby: Bool
    let species: NamedAPIResource
    let evolutionDetails: [EvolutionDetail]
    let evolvesTo: [ChainLink]
}

struct EvolutionDetail: Codable {
    let trigger: NamedAPIResource
    let minLevel: Int?
}
