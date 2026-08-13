//
//  MainTabView.swift
//  Pokedex
//
//  Created by Marcos Morales on 05/08/26.
//

import SwiftUI


struct MainTabView: View {
    private enum Tab: Hashable {
        case pokedex, favorites, team, settings
    }

    @State private var selectedTab: Tab = .pokedex

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Text("Pokédex")
                    .navigationTitle("Pokédex")
            }
            .tabItem {
                PokeBallTabIcon()
                Text("Pokédex")
            }
            .tag(Tab.pokedex)

            NavigationStack {
                Text("Favoritos")
                    .navigationTitle("Favoritos")
            }
            .tabItem {
                Image(systemName: selectedTab == .favorites ? "heart.fill" : "heart")
                Text("Favoritos")
            }
            .tag(Tab.favorites)

            NavigationStack {
                Text("Equipo")
                    .navigationTitle("Equipo")
            }
            .tabItem {
                TeamTabIcon()
                Text("Equipo")
            }
            .tag(Tab.team)

            NavigationStack {
                Text("Ajustes")
                    .navigationTitle("Ajustes")
            }
            .tabItem {
                Image(systemName: selectedTab == .settings ? "gearshape.fill" : "gearshape")
                Text("Ajustes")
            }
            .tag(Tab.settings)
        }
        .tint(Color.brand)
    }
}


@MainActor
private func templateTabImage(size: CGFloat, @ViewBuilder content: () -> some View) -> Image {
    let renderer = ImageRenderer(
        content: content()
            .foregroundStyle(.black)
            .frame(width: size, height: size)
    )
    renderer.scale = UIScreen.main.scale
    guard let uiImage = renderer.uiImage else {
        return Image(systemName: "circle")
    }
    return Image(uiImage: uiImage).renderingMode(.template)
}

/// Poké Ball glyph for the Pokédex tab: outer ring, horizontal band, center button.
private struct PokeBallTabIcon: View {
    var body: some View {
        templateTabImage(size: 24) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 1.5)
                Rectangle()
                    .frame(height: 1.5)
                Circle()
                    .frame(width: 6, height: 6)
            }
        }
    }
}

/// 6-dot grid glyph for the Equipo tab (2×3, mirroring the team builder's 6-slot grid).
private struct TeamTabIcon: View {
    var body: some View {
        templateTabImage(size: 24) {
            VStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { _ in
                    HStack(spacing: 3) {
                        Circle().frame(width: 5, height: 5)
                        Circle().frame(width: 5, height: 5)
                    }
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
