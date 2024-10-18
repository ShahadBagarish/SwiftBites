//
//  RecipeIngredientModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class RecipeIngredientModel: Identifiable, Hashable {
    
    var id = UUID()
    @Relationship var ingredient: IngredientModel
    var quantity: String
    @Relationship var recipe: RecipeModel?
    
    init() {
        id = UUID()
        ingredient = IngredientModel()
        quantity = ""
    }
    
    init(id: UUID = UUID(), ingredient: IngredientModel, quantity: String) {
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
