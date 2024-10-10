//
//  IngredientViewModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 09/10/2024.
//

import Foundation
import SwiftData
import SwiftUI
// MARK: - Ingredients
@Observable
final class IngredientViewModel {
    
    init() {}
    
    private(set) var ingredients: [IngredientModel] = []
    
    func addIngredient(name: String, modelContext: ModelContext) throws {
      guard ingredients.contains(where: { $0.name == name }) == false else {
          throw DefaultData.Error.ingredientExists
      }
        modelContext.insert(IngredientModel(name: name))
//      ingredients.append(IngredientModel(name: name))
    }

    func deleteIngredient(id: IngredientModel.ID, modelContext: ModelContext) {
      ingredients.removeAll(where: { $0.id == id })
        
    }

    func updateIngredient(id: IngredientModel.ID, name: String, modelContext: ModelContext) throws {
      guard ingredients.contains(where: { $0.name == name && $0.id != id }) == false else {
          throw DefaultData.Error.ingredientExists
      }
      guard let index = ingredients.firstIndex(where: { $0.id == id }) else {
        return
      }
      ingredients[index].name = name
    }
}
