import Foundation
import Combine

// MARK: - RecipeLibraryStore
/// Manages the full recipe catalogue: built-in (read-only) + user-created (editable).
/// Custom recipes are persisted as JSON in UserDefaults.
final class RecipeLibraryStore: ObservableObject {

    /// All recipes sorted alphabetically — built-in first, then custom mixed in.
    @Published private(set) var allRecipes: [Recipe] = []

    /// Every unique ingredient name across all recipes (for the Prices tab).
    @Published private(set) var allIngredientNames: [String] = []

    private let key = "patisserie_custom_recipes_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        loadAndMerge()
    }

    // MARK: - Public API

    func add(_ recipe: Recipe) {
        var r = recipe
        r.isCustom = true
        saveCustom(appending: r)
        loadAndMerge()
    }

    func update(_ recipe: Recipe) {
        guard recipe.isCustom else { return }
        var customs = loadCustom()
        if let idx = customs.firstIndex(where: { $0.id == recipe.id }) {
            customs[idx] = recipe
        }
        persist(customs)
        loadAndMerge()
    }

    func delete(id: UUID) {
        var customs = loadCustom()
        customs.removeAll { $0.id == id }
        persist(customs)
        loadAndMerge()
    }

    func recipe(with id: UUID) -> Recipe? {
        allRecipes.first { $0.id == id }
    }

    // MARK: - Private helpers

    private func loadAndMerge() {
        let builtIn = RecipeStore.shared.builtInRecipes
        let custom  = loadCustom()
        let merged  = (builtIn + custom).sorted {
            $0.name.localizedCompare($1.name) == .orderedAscending
        }
        allRecipes = merged
        allIngredientNames = Array(
            Set(merged.flatMap { $0.ingredients.map(\.name) })
        ).sorted { $0.localizedCompare($1) == .orderedAscending }
    }

    private func loadCustom() -> [Recipe] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let recipes = try? decoder.decode([Recipe].self, from: data)
        else { return [] }
        return recipes
    }

    private func saveCustom(appending recipe: Recipe) {
        var customs = loadCustom()
        customs.append(recipe)
        persist(customs)
    }

    private func persist(_ recipes: [Recipe]) {
        if let data = try? encoder.encode(recipes) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
