import Foundation

/// Caché de disco genérica, clave→bytes. No sabe nada de la PokeAPI ni de JSON:
/// solo guarda y devuelve `Data`. La usan tanto el caché de respuestas como el de imágenes.
actor DiskCache {
    private let fileManager = FileManager.default
    private let directory: URL

    init(directoryName: String) {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        directory = caches.appendingPathComponent(directoryName, isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    func data(for key: String) -> Data? {
        fileManager.contents(atPath: fileURL(for: key).path)
    }

    func store(_ data: Data, for key: String) {
        try? data.write(to: fileURL(for: key), options: .atomic)
    }

    func removeAll() throws {
        try fileManager.removeItem(at: directory)
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    func totalSizeInBytes() -> Int {
        guard let files = try? fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.fileSizeKey]
        ) else {
            return 0
        }
        return files.reduce(0) { total, url in
            let size = (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
            return total + size
        }
    }

    /// Convierte la key (una URL completa, p. ej. "https://pokeapi.co/api/v2/pokemon/6")
    /// en un nombre de archivo válido. Deliberadamente NO usamos `key.hashValue`:
    /// el hash de String en Swift se randomiza por proceso (protección anti-DoS),
    /// así que el mismo string produce un hash distinto cada vez que arranca la app —
    /// una caché "persistente" basada en eso jamás encontraría sus propios archivos
    /// después de un reinicio. Percent-encoding es estable entre ejecuciones.
    private func fileURL(for key: String) -> URL {
        let safeName = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return directory.appendingPathComponent(safeName)
    }
}
