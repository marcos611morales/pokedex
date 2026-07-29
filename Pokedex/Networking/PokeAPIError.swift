import Foundation

enum PokeAPIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case notFound
    case decodingFailed(Error)
}
