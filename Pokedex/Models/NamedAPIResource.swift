import Foundation

/// La forma `{ name, url }` que la PokeAPI repite en decenas de lugares
/// (`type.type`, `stat.stat`, `ability.ability`, `species.generation`, etc.).
struct NamedAPIResource: Codable {
    let name: String
    let url: String
}
