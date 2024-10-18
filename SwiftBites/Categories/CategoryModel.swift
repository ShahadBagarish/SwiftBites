//
//  CategoryModel.swift
//  SwiftBites
//
//  Created by Shahad Bagarish on 07/10/2024.
//

import Foundation
import SwiftData

@Model
final class CategoryModel: Identifiable, Hashable {

    var id = UUID()
    @Attribute(.unique) var name: String
    @Relationship var recipes: [RecipeModel]
    
    
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
