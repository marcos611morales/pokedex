import SwiftUI

/// Mismo espíritu que `AsyncImage` nativo (content/placeholder), pero respaldado
/// por `ImageCache` en disco en vez de la caché HTTP por defecto — necesario porque
/// el CDN de sprites manda `Cache-Control: max-age=300` (5 min), lo que haría que
/// `AsyncImage` revalide contra la red todo el tiempo en vez de servir offline.
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            uiImage = nil
            await loadImage()
        }
    }

    private func loadImage() async {
        guard let url else { return }
        guard let data = try? await ImageCache.loader.data(for: url),
              let image = UIImage(data: data) else { return }
        uiImage = image
    }
}
