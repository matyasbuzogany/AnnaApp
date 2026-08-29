import Foundation
import Combine

// MARK: - AssemblyStore
/// Holds the current set of recipes added to the assembly (Tab 3).
/// Published so views update automatically on add/remove.
final class AssemblyStore: ObservableObject {
    @Published private(set) var entries: [AssemblyEntry] = []

    // MARK: Mutation
    func add(recipe: Recipe, targetMass: Double) {
        entries.append(AssemblyEntry(recipe: recipe, targetMass: targetMass))
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }

    func removeEntry(id: UUID) {
        entries.removeAll { $0.id == id }
    }

    /// Replace the whole session (used when loading a saved assembly).
    func load(entries newEntries: [AssemblyEntry]) {
        entries = newEntries
    }

    func clear() {
        entries.removeAll()
    }

    // MARK: Derived data
    /// Merged ingredient list (name → total grams), sorted alphabetically.
    var mergedIngredients: [(name: String, grams: Double)] {
        var merged: [String: Double] = [:]
        for entry in entries {
            let r = entry.recipe.ratio(for: entry.targetMass)
            for ing in entry.recipe.ingredients {
                merged[ing.name, default: 0] += ing.grams * r
            }
        }
        return merged
            .map { (name: $0.key, grams: $0.value) }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    var totalMass: Double {
        mergedIngredients.reduce(0) { $0 + $1.grams }
    }

    func totalCost(prices: PriceStore) -> RecipeCost? {
        let merged = mergedIngredients
        guard !merged.isEmpty else { return nil }
        var total = 0.0
        var complete = true
        var hasAny = false
        for (name, grams) in merged {
            if let c = prices.ingredientCost(name: name, grams: grams) {
                total += c
                hasAny = true
            } else {
                complete = false
            }
        }
        guard hasAny else { return nil }
        return RecipeCost(total: total, isComplete: complete)
    }
}
