import Foundation

/// Punto único de acceso a la caché de imágenes (sprites, artwork oficial).
/// Ajustes (Fase 9) va a leer `totalSizeInBytes()` para el "24 MB" y llamar
/// `clear()` desde "Borrar caché de imágenes" — separada de la caché de
/// respuestas JSON a propósito, para que ese botón borre solo imágenes.
enum ImageCache {
    private static let cache = DiskCache(directoryName: "Images")
    static let loader: DataLoading = CachingDataLoader(cache: cache)

    static func totalSizeInBytes() async -> Int {
        await cache.totalSizeInBytes()
    }

    static func clear() async throws {
        try await cache.removeAll()
    }
}
