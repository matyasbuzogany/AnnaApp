import SwiftUI

struct ContentView: View {
    @StateObject private var priceStore = PriceStore()
    @StateObject private var assemblyStore = AssemblyStore()
    @StateObject private var library = RecipeLibraryStore()
    @StateObject private var savedAssemblyStore = SavedAssemblyStore()
    @StateObject private var ingredientStore = IngredientStore()

    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Label("Recettes", systemImage: "book.pages")
                }

            PricesView()
                .tabItem {
                    Label("Ingrédients", systemImage: "carrot")
                }

            AssemblyView()
                .tabItem {
                    Label("Assemblage", systemImage: "square.3.layers.3d")
                }
        }
        .environmentObject(priceStore)
        .environmentObject(assemblyStore)
        .environmentObject(library)
        .environmentObject(savedAssemblyStore)
        .environmentObject(ingredientStore)
    }
}

#Preview {
    ContentView()
}
