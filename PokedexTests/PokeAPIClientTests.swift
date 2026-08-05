import Testing
@testable import Pokedex

/// Estos tests golpean la PokeAPI real a propósito: son la forma de confirmar que
/// `PokemonDetail` decodifica la respuesta real, no una forma que asumimos.
/// Los ViewModels (Fase 2) se testean aparte con un cliente falso, sin red real.
struct PokeAPIClientTests {

    @Test func fetchPokemonDetailDecodesCharizard() async throws {
        let client = PokeAPIClient()

        let charizard = try await client.fetchPokemonDetail(id: 6)

        #expect(charizard.name == "charizard")
        #expect(charizard.height == 17)   // 1.7 m
        #expect(charizard.weight == 905)  // 90.5 kg
        #expect(charizard.types.map(\.type.name) == ["fire", "flying"])
        #expect(charizard.sprites.other.officialArtwork.frontDefault != nil)
    }

    @Test func fetchPokemonDetailThrowsNotFoundForInvalidID() async throws {
        let client = PokeAPIClient()

        await #expect(throws: PokeAPIError.self) {
            _ = try await client.fetchPokemonDetail(id: 999_999)
        }
    }
    
    @Test func fetchPokemonSpeciesCharizard() async throws {
        let client = PokeAPIClient()
        
        let charizard = try await client.fetchSpecies(id: 6)
        #expect(charizard.name == "charizard")
        #expect(charizard.isLegendary == false)
        await #expect(charizard.generation.name == "generation-i")
        
    }
}
