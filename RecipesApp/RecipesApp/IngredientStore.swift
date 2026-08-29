import Foundation
import Combine

// MARK: - IngredientStore
/// Manages the master list of ingredient names available for use in recipes.
/// Pre-seeded from all built-in recipe ingredients on first launch.
/// Users can add new names and delete unused ones.
/// Persisted as a JSON-encoded [String] in UserDefaults.
final class IngredientStore: ObservableObject {

    @Published private(set) var ingredientNames: [String] = []

    private let key = "patisserie_ingredient_names_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
    }

    // MARK: - Public API

    func add(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !ingredientNames.contains(trimmed) else { return }
        ingredientNames.append(trimmed)
        ingredientNames.sort { $0.localizedCompare($1) == .orderedAscending }
        persist()
    }

    func delete(name: String) {
        ingredientNames.removeAll { $0 == name }
        persist()
    }

    func delete(at offsets: IndexSet) {
        ingredientNames.remove(atOffsets: offsets)
        persist()
    }

    /// Merge additional names in (e.g. from a newly saved custom recipe).
    func merge(names: [String]) {
        var changed = false
        for name in names {
            let trimmed = name.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty, !ingredientNames.contains(trimmed) else { continue }
            ingredientNames.append(trimmed)
            changed = true
        }
        if changed {
            ingredientNames.sort { $0.localizedCompare($1) == .orderedAscending }
            persist()
        }
    }

    // MARK: - Seeding

    /// Seed from built-in recipe ingredients on first launch (key absent).
    static func seedIfNeeded(in defaults: UserDefaults = .standard) {
        let key = "patisserie_ingredient_names_v1"
        guard defaults.object(forKey: key) == nil else { return }
        let names = Array(
            Set(RecipeData.all.flatMap { $0.ingredients.map(\.name) })
        ).sorted { $0.localizedCompare($1) == .orderedAscending }
        if let data = try? JSONEncoder().encode(names) {
            defaults.set(data, forKey: key)
        }
    }

    // MARK: - Private

    private func load() {
        IngredientStore.seedIfNeeded()
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let names = try? decoder.decode([String].self, from: data)
        else { return }
        ingredientNames = names
    }

    private func persist() {
        if let data = try? encoder.encode(ingredientNames) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
