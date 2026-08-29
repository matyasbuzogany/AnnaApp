import SwiftUI

// MARK: - PricesView (Tab 2)
/// Combined ingredient management + price editing view.
/// Each row shows the ingredient name and its €/kg price.
/// • Tap the pencil icon to edit the price inline.
/// • Tap + (top right) to add a new ingredient.
/// • Swipe left on any row to delete that ingredient.
struct PricesView: View {
    @EnvironmentObject private var priceStore: PriceStore
    @EnvironmentObject private var library: RecipeLibraryStore
    @EnvironmentObject private var ingredientStore: IngredientStore

    @State private var searchText = ""
    @State private var editingIngredient: String? = nil
    @State private var editBuffer: String = ""
    @State private var showAddSheet = false
    @State private var newIngredientName = ""

    private var filteredIngredients: [String] {
        let base = ingredientStore.ingredientNames.isEmpty
            ? library.allIngredientNames
            : ingredientStore.ingredientNames
        if searchText.isEmpty { return base }
        return base.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredIngredients, id: \.self) { name in
                    PriceRow(
                        ingredientName: name,
                        price: priceStore.prices[name],
                        isEditing: editingIngredient == name,
                        editBuffer: editingIngredient == name ? $editBuffer : .constant(""),
                        onStartEdit: {
                            editBuffer = priceValueString(for: name)
                            editingIngredient = name
                        },
                        onCommit: { commit(name: name) },
                        onCancel: { editingIngredient = nil }
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // Delete the ingredient from the master list
                        Button(role: .destructive) {
                            if editingIngredient == name { editingIngredient = nil }
                            ingredientStore.delete(name: name)
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }

                        // Edit price
                        Button {
                            editBuffer = priceValueString(for: name)
                            editingIngredient = name
                        } label: {
                            Label("Prix", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Rechercher un ingrédient…"
            )
            .navigationTitle("Ingrédients & Prix")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newIngredientName = ""
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddIngredientSheet(
                    ingredientName: $newIngredientName,
                    onSave: {
                        ingredientStore.add(name: newIngredientName)
                        showAddSheet = false
                    },
                    onCancel: { showAddSheet = false }
                )
                .environmentObject(ingredientStore)
                .presentationDetents([.height(220)])
            }
        }
    }

    // MARK: - Helpers

    private func priceValueString(for name: String) -> String {
        guard let p = priceStore.prices[name] else { return "" }
        return String(format: "%.2f", p)
    }

    private func commit(name: String) {
        let value = Double(editBuffer.replacingOccurrences(of: ",", with: "."))
        priceStore.setPrice(value, for: name)
        editingIngredient = nil
    }
}

// MARK: - PriceRow
private struct PriceRow: View {
    let ingredientName: String
    let price: Double?
    let isEditing: Bool
    @Binding var editBuffer: String
    let onStartEdit: () -> Void
    let onCommit: () -> Void
    let onCancel: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(ingredientName)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isEditing {
                HStack(spacing: 4) {
                    TextField("0.00", text: $editBuffer)
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .focused($isFocused)
                        .onAppear { isFocused = true }
                        .onSubmit { onCommit() }

                    Text("€/kg")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button(action: onCommit) {
                    Text("OK")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color.accentColor, in: Capsule())
                }
                .buttonStyle(.plain)

            } else {
                Group {
                    if let p = price, p > 0 {
                        Text(String(format: "%.2f €/kg", p))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    } else {
                        Text("—")
                            .foregroundStyle(.tertiary)
                    }
                }
                .font(.subheadline)
                .monospacedDigit()

                Button(action: onStartEdit) {
                    Label("Modifier", systemImage: "pencil")
                        .labelStyle(.iconOnly)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(6)
                        .background(Color(.secondarySystemFill), in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - AddIngredientSheet
struct AddIngredientSheet: View {
    @Binding var ingredientName: String
    let onSave: () -> Void
    let onCancel: () -> Void

    @EnvironmentObject private var ingredientStore: IngredientStore
    @FocusState private var focused: Bool

    private var alreadyExists: Bool {
        ingredientStore.ingredientNames.contains(
            ingredientName.trimmingCharacters(in: .whitespaces)
        )
    }

    private var canSave: Bool {
        !ingredientName.trimmingCharacters(in: .whitespaces).isEmpty && !alreadyExists
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nom de l'ingrédient", text: $ingredientName)
                        .focused($focused)
                        .submitLabel(.done)
                        .onSubmit { if canSave { onSave() } }
                } header: {
                    Label("Nouvel ingrédient", systemImage: "plus.circle")
                } footer: {
                    if alreadyExists {
                        Text("Cet ingrédient existe déjà dans la liste.")
                            .foregroundStyle(.orange)
                            .font(.caption)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter", action: onSave)
                        .disabled(!canSave)
                        .fontWeight(.semibold)
                }
            }
            .onAppear { focused = true }
        }
    }
}
