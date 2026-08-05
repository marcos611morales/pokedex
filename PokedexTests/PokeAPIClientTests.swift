import Testing
@testable import Pokedex

/// Estos tests golpean la PokeAPI real a propósito: son la forma de confirmar que
/// `PokemonDetail` decodifica la respuesta real, no una forma que asumimos.
/// Los ViewModels (Fase 2) se testean aparte con un cliente falso, sin red real.
///
/// Usan `URLSessionDataLoader()` explícito (no el default cacheado del cliente)
/// para garantizar que siempre golpean la red real y no una respuesta vieja
/// guardada en disco de una corrida anterior — si la PokeAPI cambia de forma,
/// esto lo detecta en la siguiente corrida, no en la próxima vez que se borre la caché.
struct PokeAPIClientTests {

    @Test func fetchPokemonDetailDecodesCharizard() async throws {
        let client = PokeAPIClient(loader: URLSessionDataLoader())

        let charizard = try await client.fetchPokemonDetail(id: 6)

        #expect(charizard.name == "charizard")
        #expect(charizard.height == 17)   // 1.7 m
        #expect(charizard.weight == 905)  // 90.5 kg
        #expect(charizard.types.map(\.type.name) == ["fire", "flying"])
        #expect(charizard.sprites.other.officialArtwork.frontDefault != nil)
    }

    @Test func fetchPokemonDetailThrowsNotFoundForInvalidID() async throws {
        let client = PokeAPIClient(loader: URLSessionDataLoader())

        await #expect(throws: PokeAPIError.self) {
            _ = try await client.fetchPokemonDetail(id: 999_999)
        }
    }
    
    @Test func fetchPokemonSpeciesCharizard() async throws {
        let client = PokeAPIClient(loader: URLSessionDataLoader())
        
        let charizard = try await client.fetchSpecies(id: 6)
        #expect(charizard.name == "charizard")
        #expect(charizard.isLegendary == false)
        await #expect(charizard.generation.name == "generation-i")
        
    }
    
    @Test func fetchPokemonEvolutionChain() async throws {
        let client = PokeAPIClient(loader: URLSessionDataLoader())
        
        let species = try await client.fetchSpecies(id: 6)
        let chain = try await client.fetchEvolutionChain(url: species.evolutionChain.url)
        
        #expect(chain.chain.species.name == "charmander")
        #expect(chain.chain.evolvesTo.first?.species.name == "charmeleon")
        #expect(chain.chain.evolvesTo.first?.evolvesTo.first?.species.name == "charizard")
    }
    
    @Test func fetchPokemonTypes() async throws {
        let client = PokeAPIClient(loader: URLSessionDataLoader())
        
        let types = try await client.fetchPokemonType(name: "fire")
        #expect(types.name == "fire")
        #expect(types.damageRelations.doubleDamageFrom.contains { $0.name == "water" })
        #expect(types.damageRelations.doubleDamageTo.contains { $0.name == "grass" })
    }
}
