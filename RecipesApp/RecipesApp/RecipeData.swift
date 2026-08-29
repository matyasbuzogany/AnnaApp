// MARK: - RecipeData
// Single source of truth for all pastry recipes.
// To add a recipe, append a new Recipe(...) to the `all` array.
enum RecipeData {
    static let all: [Recipe] = [

        Recipe(name: "Appareil madeleine concours", totalBase: 818, ingredients: [
            Ingredient(name: "Farine T45", grams: 210),
            Ingredient(name: "Levure chimique", grams: 12),
            Ingredient(name: "Oeuf entier", grams: 160),
            Ingredient(name: "Miel", grams: 32),
            Ingredient(name: "Lait", grams: 64),
            Ingredient(name: "Sucre", grams: 130),
            Ingredient(name: "Beurre", grams: 210),
        ]),

        Recipe(name: "Biscuit amande cacahuète Fabrique", totalBase: 1487, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 415),
            Ingredient(name: "Sucre inverti", grams: 115),
            Ingredient(name: "Sucre semoule", grams: 115),
            Ingredient(name: "Poudre d'amande", grams: 120),
            Ingredient(name: "Crème", grams: 200),
            Ingredient(name: "Farine", grams: 220),
            Ingredient(name: "Levure chimique", grams: 12),
            Ingredient(name: "Beurre noisette", grams: 115),
            Ingredient(name: "Praline cacahuète", grams: 175),
        ]),

        Recipe(name: "Biscuit brioche perdue pavot", totalBase: 2740, ingredients: [
            Ingredient(name: "Brioche", grams: 700),
            Ingredient(name: "Pavot", grams: 240),
            Ingredient(name: "Crème liquide 35%", grams: 460),
            Ingredient(name: "Lait", grams: 800),
            Ingredient(name: "Jaune d'oeuf", grams: 120),
            Ingredient(name: "Sucre glace", grams: 120),
            Ingredient(name: "Miel", grams: 140),
            Ingredient(name: "Beurre", grams: 140),
            Ingredient(name: "Vanille", grams: 10),
            Ingredient(name: "Zeste d'agrumes", grams: 10),
        ]),

        Recipe(name: "Biscuit brownie", totalBase: 1100, ingredients: [
            Ingredient(name: "Chocolat noir", grams: 300),
            Ingredient(name: "Beurre", grams: 150),
            Ingredient(name: "Sucre semoule", grams: 300),
            Ingredient(name: "Oeuf entier", grams: 200),
            Ingredient(name: "Farine T55", grams: 150),
        ]),

        Recipe(name: "Biscuit caramel", totalBase: 1160, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 250),
            Ingredient(name: "Lait", grams: 100),
            Ingredient(name: "Beurre", grams: 250),
            Ingredient(name: "Oeuf entier", grams: 250),
            Ingredient(name: "Farine", grams: 300),
            Ingredient(name: "Levure chimique", grams: 10),
        ]),

        Recipe(name: "Biscuit coco Fabrique", totalBase: 607, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 120),
            Ingredient(name: "Sucre semoule", grams: 105),
            Ingredient(name: "Poudre d'amande", grams: 40),
            Ingredient(name: "Noix de coco râpée", grams: 112),
            Ingredient(name: "Beurre fondu", grams: 70),
            Ingredient(name: "Blanc d'oeuf", grams: 80),
            Ingredient(name: "Sucre inverti", grams: 80),
        ]),

        Recipe(name: "Biscuit cuillère", totalBase: 510, ingredients: [
            Ingredient(name: "Farine", grams: 75),
            Ingredient(name: "Fécule", grams: 50),
            Ingredient(name: "Sucre semoule", grams: 63),
            Ingredient(name: "Blanc d'oeuf", grams: 160),
            Ingredient(name: "Jaune d'oeuf", grams: 100),
            Ingredient(name: "Sucre semoule (meringue)", grams: 62),
        ]),

        Recipe(name: "Biscuit dacquois CFA", totalBase: 980, ingredients: [
            Ingredient(name: "Poudre d'amande", grams: 250),
            Ingredient(name: "Sucre glace", grams: 225),
            Ingredient(name: "Farine / Fécule", grams: 60),
            Ingredient(name: "Blanc d'oeuf", grams: 310),
            Ingredient(name: "Sucre / Cassonade", grams: 135),
        ]),

        Recipe(name: "Biscuit de Savoie", totalBase: 806, ingredients: [
            Ingredient(name: "Farine", grams: 90),
            Ingredient(name: "Maïzena", grams: 90),
            Ingredient(name: "Sucre semoule", grams: 250),
            Ingredient(name: "Jaune d'oeuf", grams: 150),
            Ingredient(name: "Blanc d'oeuf", grams: 225),
            Ingredient(name: "Sel", grams: 1),
        ]),

        Recipe(name: "Biscuit financier chocolat blanc", totalBase: 577, ingredients: [
            Ingredient(name: "Sucre glace", grams: 155),
            Ingredient(name: "Poudre d'amande", grams: 55),
            Ingredient(name: "Farine", grams: 50),
            Ingredient(name: "Levure chimique", grams: 2),
            Ingredient(name: "Blanc d'oeuf", grams: 155),
            Ingredient(name: "Beurre noisette", grams: 80),
            Ingredient(name: "Chocolat blanc", grams: 80),
        ]),

        Recipe(name: "Biscuit génoise", totalBase: 560, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 250),
            Ingredient(name: "Sucre", grams: 155),
            Ingredient(name: "Farine", grams: 155),
        ]),

        Recipe(name: "Biscuit huile d'olive Fabrique", totalBase: 1015, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 320),
            Ingredient(name: "Sucre semoule", grams: 190),
            Ingredient(name: "Zeste de citron", grams: 8),
            Ingredient(name: "Jus de citron", grams: 10),
            Ingredient(name: "Farine", grams: 200),
            Ingredient(name: "Levure chimique", grams: 7),
            Ingredient(name: "Beurre noisette", grams: 160),
            Ingredient(name: "Huile d'olive", grams: 120),
        ]),

        Recipe(name: "Biscuit joconde", totalBase: 575, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 150),
            Ingredient(name: "Poudre d'amande", grams: 125),
            Ingredient(name: "Sucre glace", grams: 125),
            Ingredient(name: "Farine T55", grams: 30),
            Ingredient(name: "Blanc d'oeuf", grams: 90),
            Ingredient(name: "Sucre", grams: 30),
            Ingredient(name: "Beurre fondu", grams: 25),
        ]),

        Recipe(name: "Biscuit madeleine cacao", totalBase: 1141, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 250),
            Ingredient(name: "Farine", grams: 250),
            Ingredient(name: "Levure chimique", grams: 11),
            Ingredient(name: "Miel", grams: 25),
            Ingredient(name: "Oeuf entier", grams: 285),
            Ingredient(name: "Beurre fondu", grams: 230),
            Ingredient(name: "Cacao en poudre", grams: 40),
            Ingredient(name: "Pépites de chocolat", grams: 50),
        ]),

        Recipe(name: "Biscuit madeleine CFA", totalBase: 413, ingredients: [
            Ingredient(name: "Sucre", grams: 100),
            Ingredient(name: "Oeuf entier", grams: 110),
            Ingredient(name: "Farine", grams: 100),
            Ingredient(name: "Levure chimique", grams: 3),
            Ingredient(name: "Beurre fondu", grams: 100),
        ]),

        Recipe(name: "Biscuit moelleux chocolat", totalBase: 998, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 240),
            Ingredient(name: "Poudre de noisette", grams: 215),
            Ingredient(name: "Poudre à crème", grams: 30),
            Ingredient(name: "Levure chimique", grams: 3),
            Ingredient(name: "Oeuf entier", grams: 145),
            Ingredient(name: "Jaune d'oeuf", grams: 60),
            Ingredient(name: "Crème liquide", grams: 215),
            Ingredient(name: "Chocolat noir", grams: 90),
        ]),

        Recipe(name: "Biscuit moelleux pain d'épice", totalBase: 1050, ingredients: [
            Ingredient(name: "Poudre d'amande", grams: 235),
            Ingredient(name: "Sucre semoule", grams: 200),
            Ingredient(name: "Oeuf entier", grams: 370),
            Ingredient(name: "Blanc d'oeuf", grams: 80),
            Ingredient(name: "Sucre semoule (meringue)", grams: 50),
            Ingredient(name: "Beurre fondu", grams: 100),
            Ingredient(name: "Poudre pain d'épice", grams: 15),
        ]),

        Recipe(name: "Pain de gênes", totalBase: 628, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 200),
            Ingredient(name: "Pâte d'amande 50%", grams: 300),
            Ingredient(name: "Levure chimique", grams: 3),
            Ingredient(name: "Farine / Fécule", grams: 45),
            Ingredient(name: "Beurre fondu", grams: 80),
        ]),

        Recipe(name: "Biscuit pâte à choux Vincent", totalBase: 995, ingredients: [
            Ingredient(name: "Miel", grams: 30),
            Ingredient(name: "Lait", grams: 135),
            Ingredient(name: "Beurre", grams: 95),
            Ingredient(name: "Farine", grams: 135),
            Ingredient(name: "Jaune d'oeuf", grams: 160),
            Ingredient(name: "Oeuf entier", grams: 100),
            Ingredient(name: "Blanc d'oeuf", grams: 240),
            Ingredient(name: "Sucre semoule", grams: 100),
        ]),

        Recipe(name: "Biscuit sacher chocolat Fabrique", totalBase: 970, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 100),
            Ingredient(name: "Jaune d'oeuf", grams: 170),
            Ingredient(name: "Oeuf entier", grams: 120),
            Ingredient(name: "Blanc d'oeuf", grams: 200),
            Ingredient(name: "Sucre", grams: 100),
            Ingredient(name: "Cacao en poudre", grams: 40),
            Ingredient(name: "Farine", grams: 80),
            Ingredient(name: "Satilla noir", grams: 80),
            Ingredient(name: "Beurre", grams: 80),
        ]),

        Recipe(name: "Biscuit sacher chocolat maison Heler", totalBase: 1630, ingredients: [
            Ingredient(name: "Beurre", grams: 200),
            Ingredient(name: "Chocolat noir", grams: 250),
            Ingredient(name: "Jaune d'oeuf", grams: 300),
            Ingredient(name: "Oeuf entier", grams: 175),
            Ingredient(name: "Sucre semoule", grams: 75),
            Ingredient(name: "Sucre inverti", grams: 25),
            Ingredient(name: "Blanc d'oeuf", grams: 225),
            Ingredient(name: "Sucre semoule (meringue)", grams: 100),
            Ingredient(name: "Poudre d'amande", grams: 200),
            Ingredient(name: "Farine T55", grams: 80),
        ]),

        Recipe(name: "Biscuit succès", totalBase: 903, ingredients: [
            Ingredient(name: "Poudre d'amande", grams: 150),
            Ingredient(name: "Sucre glace", grams: 150),
            Ingredient(name: "Farine / Fécule", grams: 3),
            Ingredient(name: "Blanc d'oeuf", grams: 300),
            Ingredient(name: "Sucre / Cassonade", grams: 300),
        ]),

        Recipe(name: "Biscuit viennois", totalBase: 595, ingredients: [
            Ingredient(name: "Oeuf entier", grams: 75),
            Ingredient(name: "Jaune d'oeuf", grams: 40),
            Ingredient(name: "Sucre glace", grams: 90),
            Ingredient(name: "Poudre d'amande", grams: 90),
            Ingredient(name: "Farine", grams: 70),
            Ingredient(name: "Blanc d'oeuf", grams: 170),
            Ingredient(name: "Sucre semoule", grams: 60),
        ]),

        Recipe(name: "Cake ricotta", totalBase: 939, ingredients: [
            Ingredient(name: "Beurre", grams: 115),
            Ingredient(name: "Sucre semoule", grams: 150),
            Ingredient(name: "Oeuf entier", grams: 170),
            Ingredient(name: "Jus de citron", grams: 45),
            Ingredient(name: "Zeste de citron", grams: 2),
            Ingredient(name: "Vanille", grams: 5),
            Ingredient(name: "Farine", grams: 140),
            Ingredient(name: "Levure chimique", grams: 2),
            Ingredient(name: "Ricotta", grams: 250),
            Ingredient(name: "Lait", grams: 60),
        ]),

        Recipe(name: "Caramel beurre salé", totalBase: 868, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 400),
            Ingredient(name: "Crème liquide", grams: 300),
            Ingredient(name: "Beurre", grams: 160),
            Ingredient(name: "Sel", grams: 8),
        ]),

        Recipe(name: "Caramel beurre salé tendre", totalBase: 900, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 210),
            Ingredient(name: "Glucose", grams: 210),
            Ingredient(name: "Crème liquide", grams: 350),
            Ingredient(name: "Beurre demi-sel", grams: 130),
        ]),

        Recipe(name: "Compoté abricot Citadelle", totalBase: 3568, ingredients: [
            Ingredient(name: "Abricot frais", grams: 2290),
            Ingredient(name: "Miel", grams: 176),
            Ingredient(name: "Sucre", grams: 176),
            Ingredient(name: "Purée d'abricot", grams: 800),
            Ingredient(name: "Maïzena", grams: 42),
            Ingredient(name: "Eau", grams: 84),
        ]),

        Recipe(name: "Compoté griotte Fabrique", totalBase: 1612, ingredients: [
            Ingredient(name: "Griotte surgelée", grams: 1100),
            Ingredient(name: "Purée framboise", grams: 200),
            Ingredient(name: "Sucre semoule", grams: 300),
            Ingredient(name: "Pectine NH", grams: 12),
        ]),

        Recipe(name: "Confit de fruits Fabrique Claire", totalBase: 1048, ingredients: [
            Ingredient(name: "Purée de fruits", grams: 600),
            Ingredient(name: "Fruits surgelés", grams: 230),
            Ingredient(name: "Glucose", grams: 115),
            Ingredient(name: "Pectine NH", grams: 13),
            Ingredient(name: "Sucre semoule", grams: 90),
        ]),

        Recipe(name: "Crème brûlée gélifiée", totalBase: 904.8, ingredients: [
            Ingredient(name: "Crème", grams: 700),
            Ingredient(name: "Jaune d'oeuf", grams: 100),
            Ingredient(name: "Sucre", grams: 100),
            Ingredient(name: "Masse gélatine", grams: 4.8),
        ]),

        Recipe(name: "Crème choux mirabelle", totalBase: 2065, ingredients: [
            Ingredient(name: "Purée de mirabelle", grams: 1000),
            Ingredient(name: "Crème liquide", grams: 400),
            Ingredient(name: "Eau de vie mirabelle", grams: 40),
            Ingredient(name: "Beurre", grams: 75),
            Ingredient(name: "Sucre", grams: 75),
            Ingredient(name: "Poudre à crème", grams: 75),
            Ingredient(name: "Oeuf entier", grams: 75),
            Ingredient(name: "Jaune d'oeuf", grams: 75),
            Ingredient(name: "Masse gélatine", grams: 60),
            Ingredient(name: "Chocolat blanc", grams: 190),
        ]),

        Recipe(name: "Crème d'amande Fabrique", totalBase: 1000, ingredients: [
            Ingredient(name: "Beurre", grams: 250),
            Ingredient(name: "Sucre glace", grams: 250),
            Ingredient(name: "Poudre d'amande", grams: 250),
            Ingredient(name: "Oeuf entier", grams: 250),
        ]),

        Recipe(name: "Crème mousseline pralinée", totalBase: 1052, ingredients: [
            Ingredient(name: "Lait", grams: 480),
            Ingredient(name: "Jaune d'oeuf", grams: 96),
            Ingredient(name: "Sucre semoule", grams: 76),
            Ingredient(name: "Beurre (1)", grams: 120),
            Ingredient(name: "Poudre à crème", grams: 40),
            Ingredient(name: "Praliné", grams: 120),
            Ingredient(name: "Beurre (2)", grams: 120),
        ]),

        Recipe(name: "Crème pâtissière Fabrique", totalBase: 2282.5, ingredients: [
            Ingredient(name: "Lait", grams: 1000),
            Ingredient(name: "Crème liquide", grams: 450),
            Ingredient(name: "Beurre", grams: 100),
            Ingredient(name: "Oeuf entier", grams: 100),
            Ingredient(name: "Jaune d'oeuf", grams: 100),
            Ingredient(name: "Sucre semoule", grams: 100),
            Ingredient(name: "Poudre à crème", grams: 100),
            Ingredient(name: "Chocolat blanc", grams: 250),
            Ingredient(name: "Masse gélatine", grams: 82.5),
        ]),

        Recipe(name: "Crèmeux 2 citrons Fabrique", totalBase: 1145, ingredients: [
            Ingredient(name: "Jus de citron vert", grams: 50),
            Ingredient(name: "Jus de citron jaune", grams: 150),
            Ingredient(name: "Zeste de citron vert", grams: 10),
            Ingredient(name: "Zeste de citron jaune", grams: 10),
            Ingredient(name: "Sucre semoule", grams: 270),
            Ingredient(name: "Oeuf entier", grams: 250),
            Ingredient(name: "Beurre", grams: 375),
            Ingredient(name: "Masse gélatine", grams: 30),
        ]),

        Recipe(name: "Crémeux carambar Fabrique", totalBase: 1070, ingredients: [
            Ingredient(name: "Crème liquide", grams: 640),
            Ingredient(name: "Carambar", grams: 300),
            Ingredient(name: "Chocolat au lait", grams: 80),
            Ingredient(name: "Masse gélatine", grams: 50),
        ]),

        Recipe(name: "Crémeux caramel chocolat Fabrique", totalBase: 1570, ingredients: [
            Ingredient(name: "Sucre semoule", grams: 345),
            Ingredient(name: "Beurre", grams: 125),
            Ingredient(name: "Crème liquide", grams: 680),
            Ingredient(name: "Glucose", grams: 45),
            Ingredient(name: "Chocolat noir", grams: 375),
        ]),

        Recipe(name: "Crémeux chocolat Timut", totalBase: 1005, ingredients: [
            Ingredient(name: "Lait", grams: 250),
            Ingredient(name: "Crème liquide", grams: 250),
            Ingredient(name: "Sucre semoule", grams: 70),
            Ingredient(name: "Jaune d'oeuf", grams: 100),
            Ingredient(name: "Poivre timut", grams: 5),
            Ingredient(name: "Chocolat noir 65%", grams: 330),
        ]),

        Recipe(name: "Crèmeux citron Fabrique", totalBase: 1270, ingredients: [
            Ingredient(name: "Jus de citron", grams: 380),
            Ingredient(name: "Jaune d'oeuf", grams: 240),
            Ingredient(name: "Oeuf entier", grams: 300),
            Ingredient(name: "Sucre", grams: 300),
            Ingredient(name: "Beurre", grams: 50),
        ]),

        Recipe(name: "Crémeux coco Fabrique", totalBase: 1095, ingredients: [
            Ingredient(name: "Coco râpée torréfiée", grams: 50),
            Ingredient(name: "Crème liquide (1)", grams: 350),
            Ingredient(name: "Masse gélatine", grams: 30),
            Ingredient(name: "Purée de coco", grams: 170),
            Ingredient(name: "Chocolat blanc", grams: 120),
            Ingredient(name: "Crème liquide (2)", grams: 375),
        ]),

        Recipe(name: "Crèmeux passion", totalBase: 942, ingredients: [
            Ingredient(name: "Purée de passion", grams: 190),
            Ingredient(name: "Sucre", grams: 210),
            Ingredient(name: "Oeuf entier", grams: 210),
            Ingredient(name: "Jaune d'oeuf", grams: 40),
            Ingredient(name: "Poudre à crème", grams: 12),
            Ingredient(name: "Beurre", grams: 280),
        ]),

        Recipe(name: "Crèmeux spéculos Fabrique", totalBase: 615, ingredients: [
            Ingredient(name: "Crème liquide", grams: 340),
            Ingredient(name: "Pâte de spéculos", grams: 100),
            Ingredient(name: "Jaune d'oeuf", grams: 80),
            Ingredient(name: "Sucre semoule", grams: 60),
            Ingredient(name: "Masse gélatine", grams: 35),
        ]),

        Recipe(name: "Crémeux yuzu", totalBase: 1000, ingredients: [
            Ingredient(name: "Lait", grams: 340),
            Ingredient(name: "Crème liquide", grams: 160),
            Ingredient(name: "Beurre", grams: 35),
            Ingredient(name: "Pulpe Yuzu", grams: 210),
            Ingredient(name: "Oeuf entier", grams: 35),
            Ingredient(name: "Jaune d'oeuf", grams: 35),
            Ingredient(name: "Poudre à crème", grams: 40),
            Ingredient(name: "Sucre semoule", grams: 40),
            Ingredient(name: "Masse gélatine", grams: 5),
            Ingredient(name: "Chocolat blanc", grams: 100),
        ]),

        Recipe(name: "Crumble Fabrique", totalBase: 1500, ingredients: [
            Ingredient(name: "Beurre", grams: 500),
            Ingredient(name: "Farine", grams: 500),
            Ingredient(name: "Sucre", grams: 250),
            Ingredient(name: "Poudre d'amande", grams: 250),
        ]),

        Recipe(name: "Diplomate coco", totalBase: 1194, ingredients: [
            Ingredient(name: "Purée de coco", grams: 525),
            Ingredient(name: "Jaune d'oeuf", grams: 105),
            Ingredient(name: "Sucre semoule", grams: 105),
            Ingredient(name: "Poudre à crème", grams: 54),
            Ingredient(name: "Masse gélatine", grams: 30),
            Ingredient(name: "Crème montée", grams: 375),
        ]),

        Recipe(name: "Flan choco coco", totalBase: 2004, ingredients: [
            Ingredient(name: "Lait de coco", grams: 880),
            Ingredient(name: "Crème de coco", grams: 400),
            Ingredient(name: "Blanc d'oeuf", grams: 50),
            Ingredient(name: "Jaune d'oeuf", grams: 190),
            Ingredient(name: "Cassonade", grams: 160),
            Ingredient(name: "Poudre à crème", grams: 54),
            Ingredient(name: "Cacao en poudre", grams: 30),
            Ingredient(name: "Chocolat noir", grams: 240),
        ]),

        Recipe(name: "Flan Fabrique", totalBase: 2095, ingredients: [
            Ingredient(name: "Lait", grams: 1035),
            Ingredient(name: "Crème liquide", grams: 470),
            Ingredient(name: "Blanc d'oeuf", grams: 60),
            Ingredient(name: "Jaune d'oeuf", grams: 230),
            Ingredient(name: "Sucre", grams: 220),
            Ingredient(name: "Poudre à crème", grams: 80),
        ]),

        Recipe(name: "Gelée rhum menthe", totalBase: 1007, ingredients: [
            Ingredient(name: "Eau", grams: 432),
            Ingredient(name: "Sucre", grams: 432),
            Ingredient(name: "Rhum", grams: 108),
            Ingredient(name: "Menthe", grams: 21),
            Ingredient(name: "Agar agar", grams: 14),
        ]),

        Recipe(name: "Marmelade orange Fabrique", totalBase: 2564, ingredients: [
            Ingredient(name: "Orange", grams: 1030),
            Ingredient(name: "Beurre", grams: 80),
            Ingredient(name: "Cassonade", grams: 80),
            Ingredient(name: "Sucre semoule", grams: 270),
            Ingredient(name: "Trimoline", grams: 130),
            Ingredient(name: "Poudre à crème", grams: 14),
            Ingredient(name: "Purée orange sanguine", grams: 600),
            Ingredient(name: "Purée clémentine", grams: 200),
            Ingredient(name: "Eau", grams: 60),
            Ingredient(name: "Sucre semoule", grams: 80),
            Ingredient(name: "Pectine NH", grams: 20),
        ]),

        Recipe(name: "Namelaka fruit chocolat au lait", totalBase: 1008, ingredients: [
            Ingredient(name: "Purée de fruits", grams: 200),
            Ingredient(name: "Chocolat au lait", grams: 380),
            Ingredient(name: "Crème", grams: 400),
            Ingredient(name: "Masse gélatine", grams: 28),
        ]),

        Recipe(name: "Namelaka fruit chocolat blanc", totalBase: 964, ingredients: [
            Ingredient(name: "Purée de fruits", grams: 200),
            Ingredient(name: "Chocolat blanc", grams: 340),
            Ingredient(name: "Crème", grams: 400),
            Ingredient(name: "Masse gélatine", grams: 24),
        ]),

        Recipe(name: "Panna cotta coco", totalBase: 350, ingredients: [
            Ingredient(name: "Lait de coco (1)", grams: 150),
            Ingredient(name: "Sirop d'agave", grams: 35),
            Ingredient(name: "Masse gélatine", grams: 15),
            Ingredient(name: "Lait de coco (2)", grams: 150),
        ]),

        Recipe(name: "Sablé amandes torréfiées", totalBase: 530, ingredients: [
            Ingredient(name: "Amandes effilées", grams: 70),
            Ingredient(name: "Farine", grams: 200),
            Ingredient(name: "Sucre glace", grams: 80),
            Ingredient(name: "Beurre", grams: 140),
            Ingredient(name: "Jaune d'oeuf", grams: 40),
        ]),

    ]
}
