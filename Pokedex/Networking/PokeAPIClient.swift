import Foundation

protocol PokeAPIClientProtocol {
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail
    func fetchSpecies(id: Int) async throws -> PokemonSpecies
    func fetchEvolutionChain(url: String) async throws -> EvolutionChain
    func fetchPokemonType(name: String) async throws -> PokemonType
}

struct PokeAPIClient: PokeAPIClientProtocol {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/")!

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        try await fetch("pokemon/\(id)")
    }
    
    func fetchSpecies(id: Int) async throws -> PokemonSpecies {
        try await fetch("pokemon-species/\(id)")
    }
    
    func fetchEvolutionChain(url: String) async throws -> EvolutionChain {
        try await fetch(url)
    }
    
    func fetchPokemonType(name: String) async throws -> PokemonType {
        try await fetch("type/\(name)")
    }

    private func fetch<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: path, relativeTo: Self.baseURL) else {
            throw PokeAPIError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw PokeAPIError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw PokeAPIError.invalidResponse
        }
        if httpResponse.statusCode == 404 {
            throw PokeAPIError.notFound
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw PokeAPIError.invalidResponse
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw PokeAPIError.decodingFailed(error)
        }
    }
}
