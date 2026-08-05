import Testing
@testable import Pokedex
import Foundation

/// Cada test usa un directorio de caché con nombre único (UUID) para no pisar
/// la caché real de la app ni interferir entre corridas de tests en paralelo.
struct DiskCacheTests {

    @Test func storesAndRetrievesData() async throws {
        let cache = DiskCache(directoryName: "TestCache-\(UUID().uuidString)")
        let payload = Data("pikachu".utf8)

        #expect(await cache.data(for: "key") == nil)
        await cache.store(payload, for: "key")
        #expect(await cache.data(for: "key") == payload)
    }

    @Test func removeAllClearsStoredData() async throws {
        let cache = DiskCache(directoryName: "TestCache-\(UUID().uuidString)")
        await cache.store(Data("pikachu".utf8), for: "key")

        try await cache.removeAll()

        #expect(await cache.data(for: "key") == nil)
    }

    @Test func totalSizeReflectsStoredBytes() async throws {
        let cache = DiskCache(directoryName: "TestCache-\(UUID().uuidString)")
        #expect(await cache.totalSizeInBytes() == 0)

        await cache.store(Data(repeating: 0, count: 1024), for: "a")

        #expect(await cache.totalSizeInBytes() == 1024)
    }
}

/// Loader falso que solo cuenta cuántas veces lo llamaron — así se puede probar
/// que CachingDataLoader de verdad evita la red en el segundo pedido, sin red real.
private actor CallCounter {
    private(set) var count = 0
    func increment() { count += 1 }
}

private struct CountingDataLoader: DataLoading {
    let payload: Data
    let counter: CallCounter

    func data(for url: URL) async throws -> Data {
        await counter.increment()
        return payload
    }
}

struct CachingDataLoaderTests {

    @Test func secondRequestForSameURLDoesNotHitWrappedLoader() async throws {
        let counter = CallCounter()
        let fakeLoader = CountingDataLoader(payload: Data("hello".utf8), counter: counter)
        let cache = DiskCache(directoryName: "TestCache-\(UUID().uuidString)")
        let sut = CachingDataLoader(wrapping: fakeLoader, cache: cache)
        let url = URL(string: "https://example.com/test")!

        let first = try await sut.data(for: url)
        let second = try await sut.data(for: url)

        #expect(first == Data("hello".utf8))
        #expect(second == Data("hello".utf8))
        #expect(await counter.count == 1)
    }
}
