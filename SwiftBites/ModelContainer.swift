//
//  ModelContainer.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 09/10/2024.
//

import Foundation
import SwiftData

@MainActor
let modelContainer: ModelContainer = {
    do {
        let schema = Schema([IngredientModel.self, CategoryModel.self, RecipeModel.self, RecipeIngredientModel.self])
        let configuration = ModelConfiguration()
        let container = try ModelContainer(for: schema, configurations: configuration)
        
        var itemFetchDescriptor = FetchDescriptor<IngredientModel>()
        itemFetchDescriptor.fetchLimit = 1
        guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
        
        // Load pre-populate data as the demo explained 
        var defaultValues = DefaultData()
        for ingredient in defaultValues.ingredients {
            container.mainContext.insert(ingredient)
        }
        for recipe in defaultValues.recipes {
            container.mainContext.insert(recipe)
        }
        for category in defaultValues.categories {
            container.mainContext.insert(category)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
