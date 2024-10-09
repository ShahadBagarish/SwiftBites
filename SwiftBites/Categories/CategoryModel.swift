//
//  CategoryModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class CategoryModel: Comparable, Identifiable, Hashable, Codable {
    
    let id: UUID
    var name: String
    var recipes: [RecipeModel] // One Category can belong to many recipes ( one-to-many)
    
    enum codingKeys: String, CodingKey {
        case id
        case name
        case recipes
    }
    
    // Decoding initializer
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.recipes = try container.decode([RecipeModel].self, forKey: .recipes)
    }
    
    // Encoding function
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(recipes, forKey: .recipes)
    }
    
    init() {
        id = UUID()
        name = ""
        recipes = []
    }
    
    init(id: UUID = UUID(), name: String, recipes: [RecipeModel]  = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
    
    static func < (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
