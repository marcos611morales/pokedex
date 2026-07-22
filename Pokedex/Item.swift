//
//  Item.swift
//  Pokedex
//
//  Created by Marcos Morales on 22/07/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
