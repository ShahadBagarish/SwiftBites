//
//  IngredientModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class IngredientModel: Comparable, Identifiable, Hashable, Codable {
    
    let id: UUID
    var name: String
    
    enum codingKeys: String, CodingKey {
        case id
        case name
    }
    
    // Decoding initializer
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    // Encoding function
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    init() {
        id = UUID()
        name = ""
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    static func < (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
