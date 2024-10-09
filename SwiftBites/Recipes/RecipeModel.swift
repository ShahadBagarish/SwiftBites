//
//  RecipeModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class RecipeModel: Comparable, Identifiable, Hashable, Codable {
    
    let id: UUID
    var name: String
    var summary: String
    var category: CategoryModel? // One recipe can belong to only-one categories ( one-to-many)
    var serving: Int
    var time: Int
    var ingredients: [RecipeIngredientModel] // One recipe can belong to many RecipeIngredient ( one-to-many)
    var instructions: String
    var imageData: Data?
    
    enum codingKeys: String, CodingKey {
        case id
        case name
        case summary
        case category
        case serving
        case time
        case ingredients
        case instructions
        case imageData
    }
    
    // Decoding initializer
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.category = try container.decode(CategoryModel?.self, forKey: .category)
        self.serving = try container.decode(Int.self, forKey: .serving)
        self.time = try container.decode(Int.self, forKey: .time)
        self.ingredients = try container.decode([RecipeIngredientModel].self, forKey: .ingredients)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.imageData = try container.decode(Data?.self, forKey: .imageData)
    }
    
    // Encoding function
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(summary, forKey: .summary)
        try container.encode(category, forKey: .category)
        try container.encode(serving, forKey: .serving)
        try container.encode(time, forKey: .time)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(imageData, forKey: .imageData)
    }
    
    init() {
        id = UUID()
        name = ""
        summary = ""
        category = CategoryModel()
        serving = 0
        time = 0
        ingredients = [RecipeIngredientModel()]
        instructions = ""
        imageData = Data()
    }
    
    init(id: UUID = UUID(), name: String, summary: String, category: CategoryModel?, serving: Int, time: Int, ingredients: [RecipeIngredientModel], instructions: String, imageData:Data?) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
    
    static func < (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
