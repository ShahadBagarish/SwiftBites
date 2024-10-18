//
//  IngredientModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class IngredientModel:  Identifiable, Hashable {
 
    var id = UUID()
    @Attribute(.unique) var name: String
    @Relationship var recipeIngredients: [RecipeIngredientModel]?
    
    
    init() {
        id = UUID()
        name = ""
    }
    
    init(id: UUID = UUID(), name: String) {
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
