//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Marcos Morales on 22/07/26.
//

import Testing
import UIKit
@testable import Pokedex

struct PokedexTests {

    /// Family name ("Pokemon Solid") y PostScript name ("PokemonSolidNormal") difieren en este archivo,
    /// y Font.custom(_:size:) solo resuelve por PostScript name. Si este test falla, el .ttf dejó de
    /// estar en el bundle o UIAppFonts en Info.plist se rompió.
    @Test func pokemonSolidFontIsRegisteredUnderItsPostScriptName() async throws {
        let names = UIFont.fontNames(forFamilyName: "Pokemon Solid")
        #expect(names == ["PokemonSolidNormal"])
    }

}
