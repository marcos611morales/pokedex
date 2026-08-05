import Foundation

/// Abstrae "conseguir los bytes de una URL". PokeAPIClient depende de esto,
/// no de URLSession directamente — así se le puede inyectar una versión con
/// caché (CachingDataLoader) sin que PokeAPIClient sepa que existe caché.
protocol DataLoading {
    func data(for url: URL) async throws -> Data
}

struct URLSessionDataLoader: DataLoading {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(for url: URL) async throws -> Data {
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
        return data
    }
}
