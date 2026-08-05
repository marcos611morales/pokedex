import Foundation

/// Decorator sobre `DataLoading`: si ya hay bytes en disco para esa URL, los devuelve
/// sin tocar la red. Si no, delega en el loader que envuelve y guarda el resultado.
/// Trata los datos como inmutables — no mira `Cache-Control` del servidor (que en
/// pokeapi.co/raw.githubusercontent.com es corto, 5 min–24 h) porque el diseño espera
/// que esto solo se borre cuando el usuario lo pide desde Ajustes.
struct CachingDataLoader: DataLoading {
    private let wrapped: DataLoading
    private let cache: DiskCache

    init(wrapping loader: DataLoading = URLSessionDataLoader(), cache: DiskCache) {
        self.wrapped = loader
        self.cache = cache
    }

    func data(for url: URL) async throws -> Data {
        if let cached = await cache.data(for: url.absoluteString) {
            return cached
        }
        let fresh = try await wrapped.data(for: url)
        await cache.store(fresh, for: url.absoluteString)
        return fresh
    }
}
