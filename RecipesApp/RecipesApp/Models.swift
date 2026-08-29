import Foundation

// MARK: - Ingredient
/// A single ingredient with its base quantity in grams.
struct Ingredient: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var grams: Double

    init(id: UUID = UUID(), name: String, grams: Double) {
        self.id = id
        self.name = name
        self.grams = grams
    }

    /// Returns the quantity scaled to a target total mass.
    func scaled(by ratio: Double) -> Double {
        grams * ratio
    }
}

// MARK: - Recipe
/// A pastry recipe with a fixed base mass and a list of ingredients.
/// `isCustom = true` means it was created by the user and can be edited/deleted.
struct Recipe: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var totalBase: Double          // grams for the base batch
    var ingredients: [Ingredient]
    var isCustom: Bool             // built-in recipes are read-only

    init(id: UUID = UUID(), name: String, totalBase: Double, ingredients: [Ingredient], isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.totalBase = totalBase
        self.ingredients = ingredients
        self.isCustom = isCustom
    }

    /// Scale ratio needed to produce `targetMass` grams.
    func ratio(for targetMass: Double) -> Double {
        guard totalBase > 0 else { return 1 }
        return targetMass / totalBase
    }

    /// Scaled ingredient list for a given target mass.
    func scaledIngredients(for targetMass: Double) -> [(ingredient: Ingredient, grams: Double)] {
        let r = ratio(for: targetMass)
        return ingredients.map { ($0, $0.scaled(by: r)) }
    }

    /// Total cost of this recipe scaled to targetMass, given a price dictionary (€/kg).
    /// Returns nil if no ingredient has a price set.
    func cost(for targetMass: Double, prices: [String: Double]) -> RecipeCost? {
        let r = ratio(for: targetMass)
        var total = 0.0
        var fullyPriced = true
        var hasAnyPrice = false

        for ing in ingredients {
            guard let pricePerKg = prices[ing.name], pricePerKg > 0 else {
                fullyPriced = false
                continue
            }
            hasAnyPrice = true
            total += (ing.grams * r / 1000.0) * pricePerKg
        }

        guard hasAnyPrice else { return nil }
        return RecipeCost(total: total, isComplete: fullyPriced)
    }
}

// MARK: - RecipeCost
struct RecipeCost {
    let total: Double
    let isComplete: Bool   // false when at least one ingredient has no price

    var displayString: String {
        let formatted = total.formatted(.currency(code: "EUR").locale(Locale(identifier: "fr_FR")))
        return isComplete ? formatted : "≥ \(formatted)"
    }
}

// MARK: - AssemblyEntry  (in-memory, for the active assembly session)
/// One recipe added to an assembly with a chosen target mass.
struct AssemblyEntry: Identifiable {
    let id = UUID()
    let recipe: Recipe
    var targetMass: Double
}

// MARK: - SavedAssemblyEntry  (Codable snapshot of one recipe+mass)
/// Lightweight Codable record that stores enough to recreate an AssemblyEntry.
struct SavedAssemblyEntry: Codable {
    var recipeId: UUID
    var recipeName: String     // kept as fallback display if recipe is deleted
    var targetMass: Double
}

// MARK: - SavedAssembly
/// A named, dated snapshot of an entire assembly session.
struct SavedAssembly: Identifiable, Codable {
    var id: UUID
    var name: String
    var date: Date
    var entries: [SavedAssemblyEntry]

    init(id: UUID = UUID(), name: String, date: Date = Date(), entries: [SavedAssemblyEntry]) {
        self.id = id
        self.name = name
        self.date = date
        self.entries = entries
    }
}

// MARK: - RecipeStore
/// Provides all recipes (built-in + custom) merged and sorted.
/// Observe `RecipeLibraryStore` for live updates; this is just the built-in read-only baseline.
final class RecipeStore {
    static let shared = RecipeStore()

    /// The immutable built-in recipes, sorted alphabetically.
    let builtInRecipes: [Recipe]

    private init() {
        builtInRecipes = RecipeData.all.sorted {
            $0.name.localizedCompare($1.name) == .orderedAscending
        }
    }
}
