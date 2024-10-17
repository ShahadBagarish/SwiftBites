import SwiftUI
import SwiftData

struct IngredientForm: View {
    enum Mode: Hashable {
        case add
        case edit(IngredientModel)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Ingredient"
        case .edit(let ingredient):
            _name = .init(initialValue: ingredient.name)
            title = "Edit \(ingredient.name)"
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var error: Error?
    //  @Environment(\.storage) private var storage
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    
    //For retrieve data using SwiftData
    @Query private var ingredient: [IngredientModel]
    @Environment(\.modelContext) var context
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .focused($isNameFocused)
            }
            if case .edit(let ingredient) = mode {
                Button(
                    role: .destructive,
                    action: {
                        delete(ingredient: ingredient)
                    },
                    label: {
                        Text("Delete Ingredient")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
            }
        }
        .onAppear {
            isNameFocused = true
        }
        .onSubmit {
            save()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(name.isEmpty)
            }
        }
    }
    
    // MARK: - Data

    private func delete(ingredient: IngredientModel) {
        print("DEBUG from FORM: \(ingredient.id)")
        
        context.delete(ingredient)
        try? context.save()
        dismiss()
    }
    
    private func save() {
      switch mode {
      case .add:
        let ingredient = IngredientModel(name: name)
        context.insert(ingredient)
      case .edit(let ingredient):
        ingredient.name = name
      }
      
      // Save changes
      do {
        try context.save()
        
        dismiss()
      } catch {
        print("Error saving context: \(error)")
      }
    }

}
