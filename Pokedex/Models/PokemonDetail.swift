import Foundation

/// `GET /pokemon/{id}`. `height` viene en decímetros y `weight` en hectogramos
/// (así lo define la PokeAPI) — la conversión a metros/kilogramos es responsabilidad
/// de quien presente el dato, no de este modelo.
struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeSlot]
    let stats: [PokemonStatEntry]
    let abilities: [PokemonAbilitySlot]
    let sprites: PokemonSprites
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: NamedAPIResource
}

struct PokemonStatEntry: Codable {
    let baseStat: Int
    let effort: Int
    let stat: NamedAPIResource
}

struct PokemonAbilitySlot: Codable {
    let ability: NamedAPIResource
    let isHidden: Bool
    let slot: Int
}

struct PokemonSprites: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let other: OtherSprites

    struct OtherSprites: Codable {
        let officialArtwork: OfficialArtwork

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }

        struct OfficialArtwork: Codable {
            let frontDefault: String?
            let frontShiny: String?
        }
    }
}
