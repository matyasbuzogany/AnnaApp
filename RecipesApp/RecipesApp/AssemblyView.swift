import SwiftUI

// MARK: - AssemblyView (Tab 3)
struct AssemblyView: View {
    @EnvironmentObject private var priceStore: PriceStore
    @EnvironmentObject private var assemblyStore: AssemblyStore
    @EnvironmentObject private var library: RecipeLibraryStore
    @EnvironmentObject private var savedAssemblyStore: SavedAssemblyStore

    @State private var selectedRecipe: Recipe? = nil
    @State private var massText: String = ""
    @State private var showSaveSheet = false
    @State private var saveName: String = ""
    @State private var showLoadConfirm: SavedAssembly? = nil

    private var targetMass: Double? {
        let v = Double(massText.replacingOccurrences(of: ",", with: "."))
        return (v != nil && v! > 0) ? v : nil
    }

    var body: some View {
        NavigationStack {
            List {

                // ── Add a recipe ──
                Section {
                    Picker("Recette", selection: $selectedRecipe) {
                        Text("Choisir…").tag(Optional<Recipe>.none)
                        ForEach(library.allRecipes) { recipe in
                            Text(recipe.name).tag(Optional(recipe))
                        }
                    }
                    .pickerStyle(.navigationLink)

                    HStack {
                        TextField("Masse (g)", text: $massText)
                            .keyboardType(.decimalPad)
                            .submitLabel(.done)
                            .onSubmit { addEntry() }
                        Text("g")
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                    }

                    Button(action: addEntry) {
                        Label("Ajouter", systemImage: "plus.circle.fill")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedRecipe == nil || targetMass == nil)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

                } header: {
                    Label("Ajouter une recette", systemImage: "plus.circle")
                }

                // ── Active session ──
                if !assemblyStore.entries.isEmpty {
                    Section {
                        ForEach(assemblyStore.entries) { entry in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(entry.recipe.name)
                                        .font(.body)
                                    Text(entry.targetMass.formattedGrams)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .onDelete { assemblyStore.remove(at: $0) }
                    } header: {
                        Label("Recettes sélectionnées (\(assemblyStore.entries.count))", systemImage: "checklist")
                    } footer: {
                        Text("Glissez à gauche pour supprimer.")
                            .font(.caption)
                    }

                    // ── Combined result link ──
                    Section {
                        NavigationLink {
                            AssemblyCombinedView()
                                .environmentObject(priceStore)
                                .environmentObject(assemblyStore)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Voir les ingrédients combinés")
                                        .font(.headline)
                                    Text("\(assemblyStore.mergedIngredients.count) ingrédients · \(assemblyStore.totalMass.formattedGrams)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    } header: {
                        Label("Résultat", systemImage: "sum")
                    }

                    // ── Save / Clear ──
                    Section {
                        Button {
                            saveName = ""
                            showSaveSheet = true
                        } label: {
                            Label("Sauvegarder l'assemblage…", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(.accentColor)

                        Button(role: .destructive) {
                            assemblyStore.clear()
                        } label: {
                            Label("Vider l'assemblage", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    // ── Empty state ──
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "birthday.cake")
                                .font(.system(size: 44))
                                .foregroundStyle(.tertiary)
                            Text("Assemblage vide")
                                .font(.headline)
                            Text("Ajoutez au moins deux recettes pour voir la liste combinée des ingrédients.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .listRowBackground(Color.clear)
                    }
                }

                // ── Saved assemblies ──
                if !savedAssemblyStore.savedAssemblies.isEmpty {
                    Section {
                        ForEach(savedAssemblyStore.savedAssemblies) { saved in
                            SavedAssemblyRow(saved: saved)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    showLoadConfirm = saved
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        savedAssemblyStore.delete(id: saved.id)
                                    } label: {
                                        Label("Supprimer", systemImage: "trash")
                                    }
                                }
                        }
                    } header: {
                        Label("Assemblages sauvegardés (\(savedAssemblyStore.savedAssemblies.count))", systemImage: "archivebox")
                    } footer: {
                        Text("Appuyez pour charger un assemblage sauvegardé.")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Assemblage")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !assemblyStore.entries.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            // ── Save sheet ──
            .sheet(isPresented: $showSaveSheet) {
                SaveAssemblySheet(
                    saveName: $saveName,
                    onSave: {
                        let trimmed = saveName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        savedAssemblyStore.save(name: trimmed, entries: assemblyStore.entries)
                        showSaveSheet = false
                    },
                    onCancel: { showSaveSheet = false }
                )
                .presentationDetents([.height(220)])
            }
            // ── Load confirmation ──
            .confirmationDialog(
                loadConfirmTitle,
                isPresented: Binding(
                    get: { showLoadConfirm != nil },
                    set: { if !$0 { showLoadConfirm = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Charger et remplacer") {
                    if let saved = showLoadConfirm {
                        let restored = savedAssemblyStore.restore(saved, using: library)
                        assemblyStore.load(entries: restored)
                    }
                    showLoadConfirm = nil
                }
                if !assemblyStore.entries.isEmpty {
                    Button("Charger et ajouter") {
                        if let saved = showLoadConfirm {
                            let restored = savedAssemblyStore.restore(saved, using: library)
                            restored.forEach { assemblyStore.add(recipe: $0.recipe, targetMass: $0.targetMass) }
                        }
                        showLoadConfirm = nil
                    }
                }
                Button("Annuler", role: .cancel) { showLoadConfirm = nil }
            } message: {
                if let saved = showLoadConfirm {
                    Text("\(saved.entries.count) recette(s) · \(saved.date.formatted(date: .abbreviated, time: .shortened))")
                }
            }
        }
    }

    private var loadConfirmTitle: String {
        showLoadConfirm.map { "Charger « \($0.name) » ?" } ?? "Charger cet assemblage ?"
    }

    private func addEntry() {
        guard let recipe = selectedRecipe, let mass = targetMass else { return }
        assemblyStore.add(recipe: recipe, targetMass: mass)
        selectedRecipe = nil
        massText = ""
        hideKeyboard()
    }
}

// MARK: - SavedAssemblyRow
private struct SavedAssemblyRow: View {
    let saved: SavedAssembly

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "archivebox")
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 3) {
                Text(saved.name)
                    .font(.body)
                    .fontWeight(.medium)
                HStack(spacing: 6) {
                    Text("\(saved.entries.count) recette(s)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Text(saved.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - SaveAssemblySheet
private struct SaveAssemblySheet: View {
    @Binding var saveName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nom de l'assemblage", text: $saveName)
                        .focused($focused)
                        .submitLabel(.done)
                        .onSubmit { if !saveName.trimmingCharacters(in: .whitespaces).isEmpty { onSave() } }
                } header: {
                    Label("Sauvegarder l'assemblage", systemImage: "square.and.arrow.down")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sauvegarder", action: onSave)
                        .disabled(saveName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .fontWeight(.semibold)
                }
            }
            .onAppear { focused = true }
        }
    }
}

// MARK: - AssemblyCombinedView
struct AssemblyCombinedView: View {
    @EnvironmentObject private var priceStore: PriceStore
    @EnvironmentObject private var assemblyStore: AssemblyStore

    private var merged: [(name: String, grams: Double)] {
        assemblyStore.mergedIngredients
    }

    private var costResult: RecipeCost? {
        assemblyStore.totalCost(prices: priceStore)
    }

    private var hasPrices: Bool {
        merged.contains { (priceStore.prices[$0.name] ?? 0) > 0 }
    }

    var body: some View {
        List {
            // ── Summary ──
            Section {
                InfoRow(label: "Ingrédients distincts", value: "\(merged.count)", icon: "list.number")
                InfoRow(label: "Masse totale", value: assemblyStore.totalMass.formattedGrams, icon: "scalemass", accent: true)
                if let cost = costResult {
                    InfoRow(
                        label: cost.isComplete ? "Coût total" : "Coût minimum",
                        value: cost.displayString,
                        icon: "eurosign.circle",
                        accent: true
                    )
                }
            } header: {
                Label("Résumé", systemImage: "info.circle")
            }

            // ── Recipes in assembly ──
            Section {
                ForEach(assemblyStore.entries) { entry in
                    HStack {
                        Text(entry.recipe.name)
                            .font(.subheadline)
                        Spacer()
                        Text(entry.targetMass.formattedGrams)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            } header: {
                Label("Recettes incluses", systemImage: "checklist")
            }

            // ── Combined ingredients ──
            Section {
                ForEach(merged, id: \.name) { item in
                    IngredientRow(
                        name: item.name,
                        grams: item.grams,
                        cost: priceStore.ingredientCost(name: item.name, grams: item.grams),
                        showCost: hasPrices
                    )
                }
            } header: {
                Label("Ingrédients combinés", systemImage: "carrot")
            }
        }
        .navigationTitle("Ingrédients combinés")
        .navigationBarTitleDisplayMode(.inline)
    }
}
