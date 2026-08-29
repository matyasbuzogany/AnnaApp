import Foundation
import Combine

// MARK: - SavedAssemblyStore
/// Persists named assembly snapshots as JSON in UserDefaults.
final class SavedAssemblyStore: ObservableObject {

    @Published private(set) var savedAssemblies: [SavedAssembly] = []

    private let key = "patisserie_saved_assemblies_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
    }

    // MARK: - Public API

    /// Save the current active assembly session under a name.
    func save(name: String, entries: [AssemblyEntry]) {
        let snapshot = SavedAssembly(
            name: name,
            entries: entries.map {
                SavedAssemblyEntry(
                    recipeId: $0.recipe.id,
                    recipeName: $0.recipe.name,
                    targetMass: $0.targetMass
                )
            }
        )
        savedAssemblies.append(snapshot)
        savedAssemblies.sort { $0.date > $1.date }   // newest first
        persist()
    }

    /// Restore a saved assembly — returns AssemblyEntries by looking up recipes.
    func restore(_ saved: SavedAssembly, using library: RecipeLibraryStore) -> [AssemblyEntry] {
        saved.entries.compactMap { entry in
            // Try to find the recipe by ID; fall back to name search
            let recipe = library.recipe(with: entry.recipeId)
                      ?? library.allRecipes.first { $0.name == entry.recipeName }
            guard let recipe else { return nil }
            return AssemblyEntry(recipe: recipe, targetMass: entry.targetMass)
        }
    }

    func delete(id: UUID) {
        savedAssemblies.removeAll { $0.id == id }
        persist()
    }

    func delete(at offsets: IndexSet) {
        savedAssemblies.remove(atOffsets: offsets)
        persist()
    }

    // MARK: - Private

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let assemblies = try? decoder.decode([SavedAssembly].self, from: data)
        else { return }
        savedAssemblies = assemblies.sorted { $0.date > $1.date }
    }

    private func persist() {
        if let data = try? encoder.encode(savedAssemblies) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
