import Foundation

protocol PokeAPIClientProtocol {
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail
    func fetchSpecies(id: Int) async throws -> PokemonSpecies
    func fetchEvolutionChain(url: String) async throws -> EvolutionChain
    func fetchPokemonType(name: String) async throws -> PokemonType
}

struct PokeAPIClient: PokeAPIClientProtocol {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/")!

    private let loader: DataLoading
    private let decoder: JSONDecoder

    init(loader: DataLoading = CachingDataLoader(cache: DiskCache(directoryName: "APIResponses"))) {
        self.loader = loader
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

        let data = try await loader.data(for: url)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw PokeAPIError.decodingFailed(error)
        }
    }
}
