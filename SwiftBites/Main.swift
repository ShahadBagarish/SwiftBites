import SwiftUI
import SwiftData
/// The main view that appears when the app is launched.
struct ContentView: View {
    
    @Environment(\.storage) private var storage //Removed later
    @Environment(\.modelContext) private var context
    
    @Query var recipes: [RecipeModel]
    @Query var ingredients: [IngredientModel]
    @Query var categories: [CategoryModel]
    
    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Label("Recipes", systemImage: "frying.pan")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }
            
            IngredientsView()
                .tabItem {
                    Label("Ingredients", systemImage: "carrot")
                }
        }
        .onAppear {
            storage.load()
        }
    }
}
