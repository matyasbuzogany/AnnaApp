// ── Prices store (persisted in localStorage) ──
const STORAGE_KEY = 'patisserie_prices';

function loadPrices() {
  try {
    const saved = localStorage.getItem(STORAGE_KEY);
    const stored = saved ? JSON.parse(saved) : {};
    // Start from current defaults, then overlay only keys that still exist
    // in PRICES_DEFAULT with any user-saved value. Stale keys (removed from
    // PRICES_DEFAULT) are silently dropped.
    const result = Object.assign({}, PRICES_DEFAULT);
    for (const key of Object.keys(stored)) {
      if (key in PRICES_DEFAULT) result[key] = stored[key];
    }
    return result;
  } catch { return Object.assign({}, PRICES_DEFAULT); }
}

function savePrices(prices) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(prices));
}

let prices = loadPrices();

// ── Collect every unique ingredient name across all recipes ──
const allIngredients = [...new Set(
  RECIPES.flatMap(r => r.ingredients.map(i => i.name))
)].sort((a, b) => a.localeCompare(b, 'fr'));

// ── DOM refs — Recettes tab ──
const select       = document.getElementById('recipeSelect');
const massInput    = document.getElementById('massInput');
const recipeMeta   = document.getElementById('recipeMeta');
const results      = document.getElementById('results');
const emptyState   = document.getElementById('emptyState');
const resultsTitle = document.getElementById('resultsTitle');
const totalBadge   = document.getElementById('totalBadge');
const totalPrix    = document.getElementById('totalPrix');
const thPrix       = document.getElementById('thPrix');
const tbody        = document.getElementById('ingredientRows');

// ── DOM refs — Prix tab ──
const pricesRows      = document.getElementById('pricesRows');
const ingredientSearch = document.getElementById('ingredientSearch');

// ── Tab switching ──
document.querySelectorAll('.tab-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById(btn.dataset.tab).classList.add('active');
  });
});

// ── Populate recipe dropdown ──
RECIPES.sort((a, b) => a.name.localeCompare(b.name, 'fr'));
RECIPES.forEach((r, i) => {
  const opt = document.createElement('option');
  opt.value = i;
  opt.textContent = r.name;
  select.appendChild(opt);
});

// ── Helpers ──
function fmtG(n) {
  const r = Math.round(n * 10) / 10;
  return r % 1 === 0 ? r.toFixed(0) + '\u00a0g' : r.toFixed(1) + '\u00a0g';
}

function fmtEur(n) {
  return n.toLocaleString('fr-FR', { style: 'currency', currency: 'EUR' });
}

// Return cost in € for `grams` of ingredient at €/kg price, or null if no price set.
function ingredientCost(name, grams) {
  const pricePerKg = prices[name];
  if (!pricePerKg || pricePerKg <= 0) return null;
  return (grams / 1000) * pricePerKg;
}

// ── Render recipe tab ──
function render() {
  const idx  = parseInt(select.value);
  const mass = parseFloat(massInput.value);

  if (isNaN(idx) || select.value === '') {
    recipeMeta.innerHTML = '';
    results.classList.remove('visible');
    emptyState.style.display = '';
    return;
  }

  const recipe = RECIPES[idx];
  recipeMeta.innerHTML =
    `Masse de base\u00a0: <strong>${recipe.totalBase}\u00a0g</strong>` +
    ` \u00a0·\u00a0 ${recipe.ingredients.length} ingrédients`;

  if (!mass || mass <= 0) {
    results.classList.remove('visible');
    emptyState.style.display = '';
    return;
  }

  const ratio = mass / recipe.totalBase;

  // Check if any ingredient in this recipe has a price set
  const hasPrices = recipe.ingredients.some(ing => prices[ing.name] > 0);
  thPrix.classList.toggle('hidden', !hasPrices);
  totalPrix.classList.toggle('hidden', !hasPrices);

  resultsTitle.textContent = recipe.name;
  totalBadge.textContent   = fmtG(mass);

  let recipeTotalCost = 0;
  let allPriced = true;

  tbody.innerHTML = recipe.ingredients.map(ing => {
    const scaledGrams = ing.grams * ratio;
    const cost = ingredientCost(ing.name, scaledGrams);
    if (cost === null) allPriced = false;
    else recipeTotalCost += cost;

    const costCell = hasPrices
      ? `<td class="col-prix">${cost !== null ? fmtEur(cost) : '<span class="no-price">—</span>'}</td>`
      : '';

    return `<tr>
      <td>${ing.name}</td>
      <td>${fmtG(scaledGrams)}</td>
      ${costCell}
    </tr>`;
  }).join('');

  if (hasPrices) {
    totalPrix.textContent = allPriced ? fmtEur(recipeTotalCost) : '≥\u00a0' + fmtEur(recipeTotalCost);
  }

  results.classList.add('visible');
  emptyState.style.display = 'none';
}

select.addEventListener('change', render);
massInput.addEventListener('input', render);

// ── Render prices tab ──
function renderPrices(filter = '') {
  const lower = filter.toLowerCase();
  const filtered = allIngredients.filter(n => n.toLowerCase().includes(lower));

  pricesRows.innerHTML = filtered.map(name => {
    const val     = prices[name] != null ? prices[name] : '';
    const display = val !== '' ? parseFloat(val).toFixed(2) : '';
    const safeN   = name.replace(/"/g, '&quot;');
    return `<tr>
      <td>${name}</td>
      <td><div class="price-input-wrap">
        <input type="number" class="price-input" min="0" step="0.01"
               placeholder="0.00" value="${display}" readonly
               data-ingredient="${safeN}" />
        <span class="price-unit">€/kg</span>
        <button class="modify-btn" data-ingredient="${safeN}">Modifier</button>
      </div></td>
    </tr>`;
  }).join('');
}

renderPrices();

// Single click handler: toggles between Modifier and Valider
pricesRows.addEventListener('click', e => {
  const btn = e.target.closest('.modify-btn');
  if (!btn) return;

  if (btn.classList.contains('confirm-btn')) {
    // Currently in edit mode → commit
    commitInput(btn.closest('tr').querySelector('.price-input'), btn);
  } else {
    // Currently locked → unlock
    const input = btn.closest('tr').querySelector('.price-input');
    input.removeAttribute('readonly');
    input.classList.add('editing');
    btn.textContent = 'Valider';
    btn.classList.add('confirm-btn');
    input.focus();
    input.select();
  }
});

pricesRows.addEventListener('focusout', e => {
  const input = e.target.closest('.price-input.editing');
  if (!input) return;
  const btn = input.closest('tr').querySelector('.modify-btn');
  commitInput(input, btn);
});

function commitInput(input, btn) {
  const name = input.dataset.ingredient;
  const val  = parseFloat(input.value);
  if (!isNaN(val) && val >= 0) {
    prices[name] = val;
    input.value  = val.toFixed(2);
  } else {
    delete prices[name];
    input.value = '';
  }
  input.setAttribute('readonly', '');
  input.classList.remove('editing');
  btn.textContent = 'Modifier';
  btn.classList.remove('confirm-btn');
  savePrices(prices);
  render();
}

ingredientSearch.addEventListener('input', e => renderPrices(e.target.value));

// ── Assembly tab ──────────────────────────────────────────────

const assemblyRecipeSelect = document.getElementById('assemblyRecipeSelect');
const assemblyMassInput    = document.getElementById('assemblyMassInput');
const assemblyAddBtn       = document.getElementById('assemblyAddBtn');
const assemblyListCard     = document.getElementById('assemblyListCard');
const assemblyListRows     = document.getElementById('assemblyListRows');
const assemblyResults      = document.getElementById('assemblyResults');
const assemblyEmptyState   = document.getElementById('assemblyEmptyState');
const assemblyIngRows      = document.getElementById('assemblyIngredientRows');
const assemblyTotalMass    = document.getElementById('assemblyTotalMass');
const assemblyTotalPrix    = document.getElementById('assemblyTotalPrix');
const assemblyThPrix       = document.getElementById('assemblyThPrix');

// Populate assembly dropdown (same sorted list as recipes tab)
RECIPES.forEach((r, i) => {
  const opt = document.createElement('option');
  opt.value = i;
  opt.textContent = r.name;
  assemblyRecipeSelect.appendChild(opt);
});

// Each entry: { recipeIdx, mass }
let assembly = [];

function renderAssembly() {
  // ── Selected recipes list ──
  if (assembly.length === 0) {
    assemblyListCard.style.display = 'none';
    assemblyResults.style.display  = 'none';
    assemblyEmptyState.style.display = '';
    return;
  }

  assemblyListCard.style.display   = '';
  assemblyEmptyState.style.display = 'none';

  assemblyListRows.innerHTML = assembly.map((entry, i) => {
    const r = RECIPES[entry.recipeIdx];
    return `<tr>
      <td>${r.name}</td>
      <td>${fmtG(entry.mass)}</td>
      <td><button class="remove-btn" data-idx="${i}" title="Supprimer">✕</button></td>
    </tr>`;
  }).join('');

  // ── Combined ingredients ──
  // Merge all scaled ingredients across all recipes
  const merged = {}; // name → total grams
  for (const entry of assembly) {
    const recipe = RECIPES[entry.recipeIdx];
    const ratio  = entry.mass / recipe.totalBase;
    for (const ing of recipe.ingredients) {
      merged[ing.name] = (merged[ing.name] || 0) + ing.grams * ratio;
    }
  }

  // Sort combined list alphabetically
  const combined = Object.entries(merged)
    .sort(([a], [b]) => a.localeCompare(b, 'fr'));

  const totalGrams = combined.reduce((s, [, g]) => s + g, 0);

  // Check if any ingredient has a price
  const hasPrices = combined.some(([name]) => prices[name] > 0);
  assemblyThPrix.classList.toggle('hidden', !hasPrices);
  assemblyTotalPrix.classList.toggle('hidden', !hasPrices);

  let grandTotal = 0;
  let allPriced  = true;

  assemblyIngRows.innerHTML = combined.map(([name, grams]) => {
    const cost = ingredientCost(name, grams);
    if (cost === null) allPriced = false;
    else grandTotal += cost;

    const costCell = hasPrices
      ? `<td class="col-prix">${cost !== null ? fmtEur(cost) : '<span class="no-price">—</span>'}</td>`
      : '';

    return `<tr>
      <td>${name}</td>
      <td>${fmtG(grams)}</td>
      ${costCell}
    </tr>`;
  }).join('');

  assemblyTotalMass.textContent = fmtG(totalGrams);
  if (hasPrices) {
    assemblyTotalPrix.textContent = allPriced
      ? fmtEur(grandTotal)
      : '≥\u00a0' + fmtEur(grandTotal);
  }

  assemblyResults.style.display = '';
}

// Add button
assemblyAddBtn.addEventListener('click', () => {
  const idx  = parseInt(assemblyRecipeSelect.value);
  const mass = parseFloat(assemblyMassInput.value);
  if (isNaN(idx) || assemblyRecipeSelect.value === '') return;
  if (!mass || mass <= 0) { assemblyMassInput.focus(); return; }

  assembly.push({ recipeIdx: idx, mass });
  assemblyRecipeSelect.value = '';
  assemblyMassInput.value    = '';
  renderAssembly();
});

// Also add on Enter inside the mass field
assemblyMassInput.addEventListener('keydown', e => {
  if (e.key === 'Enter') assemblyAddBtn.click();
});

// Remove a recipe from the list
assemblyListRows.addEventListener('click', e => {
  const btn = e.target.closest('.remove-btn');
  if (!btn) return;
  assembly.splice(parseInt(btn.dataset.idx), 1);
  renderAssembly();
});
