import SwiftUI

// MARK: - RecipeEditView
/// Modal form for creating a new recipe or editing an existing custom one.
struct RecipeEditView: View {

    enum Mode {
        case create
        case edit(Recipe)
    }

    @EnvironmentObject private var library: RecipeLibraryStore
    @EnvironmentObject private var ingredientStore: IngredientStore
    @Environment(\.dismiss) private var dismiss

    let mode: Mode

    // Form state
    @State private var name: String = ""
    @State private var totalBaseText: String = ""
    @State private var ingredients: [Ingredient] = []
    @State private var showPickIngredient = false
    @State private var editingIngredientIndex: Int? = nil

    // Validation
    private var totalBase: Double? {
        let v = Double(totalBaseText.replacingOccurrences(of: ",", with: "."))
        return (v != nil && v! > 0) ? v : nil
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && totalBase != nil
        && !ingredients.isEmpty
    }

    private var title: String {
        switch mode {
        case .create: return "Nouvelle recette"
        case .edit:   return "Modifier la recette"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                // ── Basic info ──
                Section {
                    TextField("Nom de la recette", text: $name)
                        .submitLabel(.next)
                    HStack {
                        TextField("ex: 1000", text: $totalBaseText)
                            .keyboardType(.decimalPad)
                        Text("g  (masse de base)")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                } header: {
                    Label("Informations", systemImage: "info.circle")
                } footer: {
                    Text("La masse de base correspond à la quantité totale produite par la recette.")
                        .font(.caption)
                }

                // ── Ingredients list ──
                Section {
                    ForEach(ingredients.indices, id: \.self) { idx in
                        IngredientEditRow(
                            ingredient: $ingredients[idx],
                            onPickName: {
                                editingIngredientIndex = idx
                                showPickIngredient = true
                            }
                        )
                    }
                    .onDelete { ingredients.remove(atOffsets: $0) }
                    .onMove  { ingredients.move(fromOffsets: $0, toOffset: $1) }

                    Button {
                        withAnimation {
                            ingredients.append(Ingredient(name: "", grams: 0))
                        }
                    } label: {
                        Label("Ajouter un ingrédient", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                } header: {
                    HStack {
                        Label("Ingrédients", systemImage: "carrot")
                        Spacer()
                        if !ingredients.isEmpty {
                            EditButton()
                                .font(.caption)
                        }
                    }
                } footer: {
                    if ingredients.isEmpty {
                        Text("Ajoutez au moins un ingrédient.")
                            .font(.caption)
                    } else {
                        Text("Touchez le nom pour choisir dans la liste.")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") { save() }
                        .disabled(!isValid)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .keyboard) {
                    Button("OK") { hideKeyboard() }
                }
            }
            .onAppear { prefill() }
            // ── Ingredient name picker sheet ──
            .sheet(isPresented: $showPickIngredient) {
                IngredientPickerSheet(
                    selected: editingIngredientIndex.map { ingredients[$0].name } ?? "",
                    onSelect: { pickedName in
                        if let idx = editingIngredientIndex {
                            ingredients[idx].name = pickedName
                        }
                        showPickIngredient = false
                    },
                    onCancel: { showPickIngredient = false }
                )
                .environmentObject(ingredientStore)
            }
        }
    }

    // MARK: - Helpers

    private func prefill() {
        if case .edit(let recipe) = mode {
            name = recipe.name
            totalBaseText = String(format: "%g", recipe.totalBase)
            ingredients = recipe.ingredients
        }
    }

    private func save() {
        guard let base = totalBase else { return }
        let clean = ingredients.filter {
            !$0.name.trimmingCharacters(in: .whitespaces).isEmpty && $0.grams > 0
        }
        // Auto-register any new ingredient names entered manually
        ingredientStore.merge(names: clean.map(\.name))

        switch mode {
        case .create:
            let recipe = Recipe(
                name: name.trimmingCharacters(in: .whitespaces),
                totalBase: base,
                ingredients: clean,
                isCustom: true
            )
            library.add(recipe)
        case .edit(let original):
            var updated = original
            updated.name = name.trimmingCharacters(in: .whitespaces)
            updated.totalBase = base
            updated.ingredients = clean
            library.update(updated)
        }
        dismiss()
    }
}

// MARK: - IngredientEditRow
/// Editable row: tap the name button to open the picker, type grams directly.
private struct IngredientEditRow: View {
    @Binding var ingredient: Ingredient
    let onPickName: () -> Void

    @State private var gramsText: String = ""
    @FocusState private var gramsFieldFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            // Name — tappable button that opens the picker
            Button(action: onPickName) {
                HStack {
                    Text(ingredient.name.isEmpty ? "Choisir un ingrédient…" : ingredient.name)
                        .foregroundStyle(ingredient.name.isEmpty ? .tertiary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)

            // Grams field
            TextField("0", text: $gramsText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 70)
                .focused($gramsFieldFocused)
                .onChange(of: gramsText) { new in
                    let v = Double(new.replacingOccurrences(of: ",", with: ".")) ?? 0
                    ingredient.grams = v
                }
                .onChange(of: gramsFieldFocused) { focused in
                    if !focused && gramsText.isEmpty {
                        gramsText = ingredient.grams > 0 ? String(format: "%g", ingredient.grams) : ""
                    }
                }

            Text("g")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
        .onAppear {
            gramsText = ingredient.grams > 0 ? String(format: "%g", ingredient.grams) : ""
        }
    }
}

// MARK: - IngredientPickerSheet
/// Full-screen searchable list of all known ingredients. Tap to pick, or type a custom name.
struct IngredientPickerSheet: View {
    let selected: String
    let onSelect: (String) -> Void
    let onCancel: () -> Void

    @EnvironmentObject private var ingredientStore: IngredientStore
    @State private var searchText = ""

    private var filtered: [String] {
        if searchText.isEmpty { return ingredientStore.ingredientNames }
        return ingredientStore.ingredientNames.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    // If the user typed something not in the list, offer to use it directly
    private var exactMatch: Bool {
        let t = searchText.trimmingCharacters(in: .whitespaces)
        return t.isEmpty || ingredientStore.ingredientNames.contains(t)
    }

    var body: some View {
        NavigationStack {
            List {
                // "Use as-is" row when user typed a custom name not in the list
                if !searchText.trimmingCharacters(in: .whitespaces).isEmpty && !exactMatch {
                    Section {
                        Button {
                            onSelect(searchText.trimmingCharacters(in: .whitespaces))
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(Color.accentColor)
                                Text("Utiliser « \(searchText.trimmingCharacters(in: .whitespaces)) »")
                                    .foregroundStyle(.primary)
                            }
                        }
                    } footer: {
                        Text("Cet ingrédient sera ajouté à votre liste.")
                            .font(.caption)
                    }
                }

                Section {
                    ForEach(filtered, id: \.self) { name in
                        Button {
                            onSelect(name)
                        } label: {
                            HStack {
                                Text(name)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if name == selected {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Rechercher ou saisir un ingrédient…"
            )
            .navigationTitle("Choisir un ingrédient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler", action: onCancel)
                }
            }
        }
    }
}
