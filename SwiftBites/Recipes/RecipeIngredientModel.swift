//
//  RecipeIngredientModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class RecipeIngredientModel: Comparable, Identifiable, Hashable, Codable {
    
    let id: UUID
    var ingredient: IngredientModel
    var quantity: String
    
    enum codingKeys: String, CodingKey {
        case id
        case ingredient
        case quantity
    }
    
    // Decoding initializer
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.ingredient = try container.decode(IngredientModel.self, forKey: .ingredient)
        self.quantity = try container.decode(String.self, forKey: .quantity)
    }
    
    // Encoding function
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ingredient, forKey: .ingredient)
        try container.encode(quantity, forKey: .quantity)
    }
    
    init() {
        id = UUID()
        ingredient = IngredientModel()
        quantity = ""
    }
    
    init(id: UUID, ingredient: IngredientModel, quantity: String) {
        self.id = id
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
    static func < (lhs: RecipeIngredientModel, rhs: RecipeIngredientModel) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: RecipeIngredientModel, rhs: RecipeIngredientModel) -> Bool {
        return lhs.id == rhs.id && lhs.ingredient == rhs.ingredient
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
