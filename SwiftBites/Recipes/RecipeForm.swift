import SwiftUI
import PhotosUI
import Foundation
import SwiftData

struct RecipeForm: View {
    enum Mode: Hashable {
        case add
        case edit(RecipeModel)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            title = "Add Recipe"
            _name = .init(initialValue: "")
            _summary = .init(initialValue: "")
            _serving = .init(initialValue: 1)
            _time = .init(initialValue: 5)
            _instructions = .init(initialValue: "")
            _ingredients = .init(initialValue: [])
        case .edit(let recipe):
            title = "Edit \(recipe.name)"
            _name = .init(initialValue: recipe.name)
            _summary = .init(initialValue: recipe.summary)
            _serving = .init(initialValue: recipe.serving)
            _time = .init(initialValue: recipe.time)
            _instructions = .init(initialValue: recipe.instructions)
            _ingredients = .init(initialValue: recipe.ingredients)
            _category = .init(initialValue: recipe.category ?? CategoryModel())
            _imageData = .init(initialValue: recipe.imageData)
            
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var summary: String
    @State private var serving: Int
    @State private var time: Int
    @State private var instructions: String
    @State private var category: CategoryModel?
    @State private var ingredients: [RecipeIngredientModel]
    @State private var imageItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isIngredientsPickerPresented =  false
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    @Query(FetchDescriptor<CategoryModel>(sortBy: [SortDescriptor(\CategoryModel.name)]))
    private var categories: [CategoryModel]
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                imageSection(width: geometry.size.width)
                nameSection
                summarySection
                categorySection
                servingAndTimeSection
                ingredientsSection
                instructionsSection
                deleteButton
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(error: $error)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(name.isEmpty || instructions.isEmpty)
            }
        }
        .onChange(of: imageItem) { _, _ in
            Task {
                self.imageData = try? await imageItem?.loadTransferable(type: Data.self)
            }
        }
        .sheet(isPresented: $isIngredientsPickerPresented, content: ingredientPicker)
    }
    
    // MARK: - Views
    
    private func ingredientPicker() -> some View {
        IngredientsView { selectedIngredient in
            let recipeIngredient = RecipeIngredientModel(ingredient: selectedIngredient, quantity: "")
            context.insert(recipeIngredient)
            ingredients.append(recipeIngredient)
        }
    }
    
    @ViewBuilder
    private func imageSection(width: CGFloat) -> some View {
        Section {
            imagePicker(width: width)
            removeImage
        }
    }
    
    @ViewBuilder
    private func imagePicker(width: CGFloat) -> some View {
        PhotosPicker(selection: $imageItem, matching: .images) {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .center)
            } else {
                Label("Select Image", systemImage: "photo")
            }
        }
    }
    
    @ViewBuilder
    private var removeImage: some View {
        if imageData != nil {
            Button(
                role: .destructive,
                action: {
                    imageData = nil
                },
                label: {
                    Text("Remove Image")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section("Name") {
            TextField("Margherita Pizza", text: $name)
        }
    }
    
    @ViewBuilder
    private var summarySection: some View {
        Section("Summary") {
            TextField(
                "Delicious blend of fresh basil, mozzarella, and tomato on a crispy crust.",
                text: $summary,
                axis: .vertical
            )
            .lineLimit(3...5)
        }
    }
    
    @ViewBuilder
    private var categorySection: some View {
        Section {
            Picker("Category", selection: $category) {
                Text("None").tag(nil as CategoryModel?)
                ForEach(categories) { category in
                    Text(category.name).tag(category as CategoryModel?)
                }
            }
        }
    }
    
    @ViewBuilder
    private var servingAndTimeSection: some View {
        Section {
            Stepper("Servings: \(serving)p", value: $serving, in: 1...100)
            Stepper("Time: \(time)m", value: $time, in: 5...300, step: 5)
        }
        .monospacedDigit()
    }
    
    @ViewBuilder
    private var ingredientsSection: some View {
        Section("Ingredients") {
            if ingredients.isEmpty {
                ContentUnavailableView(
                    label: {
                        Label("No Ingredients", systemImage: "list.clipboard")
                    },
                    description: {
                        Text("Recipe ingredients will appear here.")
                    },
                    actions: {
                        Button("Add Ingredient") {
                            isIngredientsPickerPresented = true
                        }
                    }
                )
            } else {
                ForEach(ingredients) { ingredient in
                    HStack(alignment: .center) {
                        Text(ingredient.ingredient.name)
                            .bold()
                            .layoutPriority(2)
                        Spacer()
                        TextField("Quantity", text: .init(
                            get: {
                                ingredient.quantity
                            },
                            set: { quantity in
                                if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    ingredients[index].quantity = quantity
                                }
                            }
                        ))
                        .layoutPriority(1)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deleteRecipeIngredient(recipeIngredient: ingredient)
                        }
                    }
                }
                
                Button("Add Ingredient") {
                    isIngredientsPickerPresented = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var instructionsSection: some View {
        Section("Instructions") {
            TextField(
        """
        1. Preheat the oven to 475°F (245°C).
        2. Roll out the dough on a floured surface.
        3. ...
        """,
        text: $instructions,
        axis: .vertical
            )
            .lineLimit(8...12)
        }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        if case .edit(let recipe) = mode {
            Button(
                role: .destructive,
                action: {
                    delete(recipe: recipe)
                },
                label: {
                    Text("Delete Recipe")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        }
    }
    
    
    // MARK: - Data
    
    private func delete(recipe: RecipeModel) {
        guard case .edit(let recipe) = mode else {
            fatalError("Delete unavailable in add mode")
        }
        
        ingredients.removeAll()
        for ingredient in recipe.ingredients {
            context.delete(ingredient)
        }
        
        if let oldCategory = recipe.category, let category = category {
            if oldCategory != category {
                oldCategory.recipes.removeAll { $0 == recipe }
                category.recipes.append(recipe)
            }
        }
        recipe.category = nil
        context.delete(recipe)
        
        if let category = category {
            category.recipes.append(recipe)
        }
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving context: \(error)")
        }
        
    }
    
    private func deleteRecipeIngredient(recipeIngredient: RecipeIngredientModel) {
        let recipeId = recipeIngredient.id
        switch mode {
        case .add:
            withAnimation {
                ingredients.removeAll(where: { $0.id == recipeId })
            }
        case .edit:
            withAnimation {
                ingredients.removeAll(where: { $0.id == recipeId })
            }
        }
    }
    
    private func save() {
        let category = categories.first(where: { $0 == self.category })
        
        switch mode {
        case .add:
            let recipe = RecipeModel(name: name,
                                     summary: summary,
                                     category: category,
                                     serving: serving,
                                     time: time,
                                     ingredients: [],
                                     instructions: instructions,
                                     imageData: imageData)
            
            recipe.ingredients = ingredients
            recipe.category = category
            context.insert(recipe)
            
            if let category = category {
                category.recipes.append(recipe)
            }
            
        case .edit(let recipe):
            if let oldCategory = recipe.category, let category = category {
                if oldCategory != category {
                    oldCategory.recipes.removeAll { $0 == recipe }
                    category.recipes.append(recipe)
                }
            }
            
            recipe.name = name
            recipe.summary = summary
            recipe.category = category
            recipe.serving = serving
            recipe.time = time
            recipe.instructions = instructions
            recipe.imageData = imageData
            
            let currentIngredientIds = Set(recipe.ingredients.map { $0.id })
            let newIngredientIds = Set(ingredients.map { $0.id })
            
            for ingredient in recipe.ingredients {
                if !newIngredientIds.contains(ingredient.id) {
                    context.delete(ingredient)
                }
            }
            
            for ingredient in ingredients {
                if !currentIngredientIds.contains(ingredient.id) {
                    context.insert(ingredient)
                }
                ingredient.recipe = recipe
            }
            
            recipe.ingredients = ingredients
            recipe.category = category
            context.insert(recipe)
            
            if let category = category {
                category.recipes.append(recipe)
            }
        }
        do {
            try context.save()
            
            dismiss()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
