import SwiftUI

// MARK: - Helpers (shared formatting)
extension Double {
    /// Format as grams: "150 g" or "150.5 g"
    var formattedGrams: String {
        let rounded = (self * 10).rounded() / 10
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(rounded)) g"
        } else {
            return String(format: "%.1f g", rounded)
        }
    }

    /// Format as currency in French locale
    var formattedEUR: String {
        self.formatted(.currency(code: "EUR").locale(Locale(identifier: "fr_FR")))
    }
}

// MARK: - RecipesView  (Tab 1)
struct RecipesView: View {
    @EnvironmentObject private var priceStore: PriceStore
    @EnvironmentObject private var library: RecipeLibraryStore
    @EnvironmentObject private var ingredientStore: IngredientStore

    @State private var searchText = ""
    @State private var showNewRecipe = false
    @State private var recipeToEdit: Recipe? = nil

    private var filtered: [Recipe] {
        if searchText.isEmpty { return library.allRecipes }
        return library.allRecipes.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                            .environmentObject(priceStore)
                            .environmentObject(library)
                    } label: {
                        RecipeRowView(recipe: recipe)
                    }
                    // swipe actions: custom recipes get Edit + Delete; built-ins get nothing
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if recipe.isCustom {
                            Button(role: .destructive) {
                                library.delete(id: recipe.id)
                            } label: {
                                Label("Supprimer", systemImage: "trash")
                            }
                            Button {
                                recipeToEdit = recipe
                            } label: {
                                Label("Modifier", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Rechercher une recette…"
            )
            .navigationTitle("Recettes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewRecipe = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewRecipe) {
                RecipeEditView(mode: .create)
                    .environmentObject(library)
                    .environmentObject(ingredientStore)
            }
            .sheet(item: $recipeToEdit) { recipe in
                RecipeEditView(mode: .edit(recipe))
                    .environmentObject(library)
                    .environmentObject(ingredientStore)
            }
        }
    }
}

// MARK: - RecipeRowView
private struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(recipe.name)
                    .font(.body)
                HStack(spacing: 8) {
                    Text("\(recipe.ingredients.count) ingrédients")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Text("base \(recipe.totalBase.formattedGrams)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if recipe.isCustom {
                Image(systemName: "person.fill")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(5)
                    .background(Color(.secondarySystemFill), in: Circle())
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - RecipeDetailView
struct RecipeDetailView: View {
    let recipe: Recipe

    @EnvironmentObject private var priceStore: PriceStore
    @EnvironmentObject private var library: RecipeLibraryStore
    @EnvironmentObject private var ingredientStore: IngredientStore

    @State private var targetMassText: String = ""
    @State private var showEdit = false

    private var targetMass: Double? {
        let v = Double(targetMassText.replacingOccurrences(of: ",", with: "."))
        return (v != nil && v! > 0) ? v : nil
    }

    private var scaled: [(ingredient: Ingredient, grams: Double)] {
        guard let mass = targetMass else {
            return recipe.ingredients.map { ($0, $0.grams) }
        }
        return recipe.scaledIngredients(for: mass)
    }

    private var costResult: RecipeCost? {
        guard let mass = targetMass else { return nil }
        return recipe.cost(for: mass, prices: priceStore.prices)
    }

    private var hasPrices: Bool {
        recipe.ingredients.contains { (priceStore.prices[$0.name] ?? 0) > 0 }
    }

    var body: some View {
        List {
            // ── Mass scaler ──
            Section {
                HStack {
                    TextField("ex: 1000", text: $targetMassText)
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                    Text("g")
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Base de la recette")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    Spacer()
                    Text(recipe.totalBase.formattedGrams)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                }
                if let cost = costResult {
                    HStack {
                        Text(cost.isComplete ? "Coût total" : "Coût minimum")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Text(cost.displayString)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            } header: {
                Label("Masse souhaitée", systemImage: "scalemass")
            } footer: {
                if targetMass == nil {
                    Text("Laissez vide pour voir les quantités de base.")
                        .font(.caption)
                }
            }

            // ── Ingredients ──
            Section {
                ForEach(scaled, id: \.ingredient.id) { item in
                    IngredientRow(
                        name: item.ingredient.name,
                        grams: item.grams,
                        cost: targetMass != nil
                            ? priceStore.ingredientCost(name: item.ingredient.name, grams: item.grams)
                            : nil,
                        showCost: hasPrices && targetMass != nil
                    )
                }
            } header: {
                Label("Ingrédients (\(recipe.ingredients.count))", systemImage: "carrot")
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if recipe.isCustom {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEdit = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
            ToolbarItem(placement: .keyboard) {
                Button("OK") { hideKeyboard() }
            }
        }
        .sheet(isPresented: $showEdit) {
            if let current = library.recipe(with: recipe.id) {
                RecipeEditView(mode: .edit(current))
                    .environmentObject(library)
                    .environmentObject(ingredientStore)
            }
        }
    }
}

// MARK: - Reusable row components

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    var accent: Bool = false

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(accent ? Color.accentColor : .primary)
        }
    }
}

struct IngredientRow: View {
    let name: String
    let grams: Double
    let cost: Double?
    let showCost: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(name)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(grams.formattedGrams)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.accentColor)
                .monospacedDigit()
                .frame(minWidth: 70, alignment: .trailing)

            if showCost {
                Group {
                    if let c = cost {
                        Text(c.formattedEUR)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("—")
                            .foregroundStyle(.tertiary)
                    }
                }
                .font(.caption)
                .monospacedDigit()
                .frame(minWidth: 60, alignment: .trailing)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Keyboard dismiss helper
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
