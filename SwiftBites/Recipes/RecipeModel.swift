//
//  RecipeModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class RecipeModel: Identifiable, Hashable {
    
    let id: UUID
    @Attribute(.unique) var name: String
    var summary: String
    @Relationship(deleteRule: .nullify) var category: CategoryModel? // One recipe can belong to only-one categories ( one-to-many)
    var serving: Int
    var time: Int
    @Relationship(deleteRule: .cascade) var ingredients: [RecipeIngredientModel] // One recipe can belong to many RecipeIngredient ( one-to-many)
    var instructions: String
    var imageData: Data?
    
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
