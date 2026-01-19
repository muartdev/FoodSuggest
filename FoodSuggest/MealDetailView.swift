import SwiftUI
import Foundation

struct MealDetailView: View {
    let meal: Meal

    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var intake: TodayIntakeStore
    @EnvironmentObject private var shopping: ShoppingListStore

    @State private var isShoppingAddedAlertPresented = false

    private var isRunningForPreviews: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                hero

                titleSection

                aboutCard
                ingredientsCard

                macrosSummaryCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(AppBackgroundView())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isRunningForPreviews {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .accessibilityLabel("Share")
                } else {
                    ShareLink(item: shareText) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Share")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomActions
        }
        .alert("Added to Shopping List", isPresented: $isShoppingAddedAlertPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Ingredients were added to your shopping list.")
        }
    }

    private var hero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 24, x: 0, y: 14)

            ZStack {
                if let asset = meal.imageAsset, UIImage(named: asset) != nil {
                    Image(asset)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [Color.black.opacity(0.00), Color.black.opacity(0.18)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                } else {
                    LinearGradient(
                        colors: [
                            accent.opacity(0.25),
                            accent.opacity(0.08),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: meal.imageName)
                        .font(.system(size: 62, weight: .semibold))
                        .foregroundStyle(accent)
                        .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 10)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(14)
        }
        .frame(height: 260)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(meal.name)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 0)

                Text("\(meal.calories) kcal")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }

            Text(meal.description)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)

            HStack(spacing: 10) {
                Text("Cuisine")
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
                Text(meal.cuisine)
                    .foregroundStyle(.primary)
            }
            .font(.subheadline)

            HStack(spacing: 10) {
                Text("Meal type")
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
                Text(meal.category)
                    .foregroundStyle(.primary)
            }
            .font(.subheadline)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 10)
    }

    private var ingredientsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ingredients")
                    .font(.headline)

                Spacer(minLength: 0)

                Button {
                    shopping.addAll(
                        ingredients.map { (name: $0.name, quantity: $0.quantity) },
                        sourceMeal: meal.name
                    )
                    isShoppingAddedAlertPresented = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "cart.badge.plus")
                            .font(.subheadline.weight(.semibold))
                        Text("Add")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(ingredients, id: \.name) { item in
                    HStack(spacing: 10) {
                        Image(systemName: item.symbol)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 22)

                        Text(item.name)
                            .foregroundStyle(.primary)

                        Spacer(minLength: 0)

                        Text(item.quantity)
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 10)
    }

    private var macrosSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Macros")
                .font(.headline)

            HStack(spacing: 14) {
                MacroStat(label: "Carbs", value: "\(meal.carbs)g")
                MacroStat(label: "Protein", value: "\(meal.protein)g")
                MacroStat(label: "Fat", value: "\(meal.fat)g")
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 10)
    }

    private var bottomActions: some View {
        HStack(spacing: 12) {
            Button {
                intake.add(meal: meal)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.subheadline.weight(.semibold))
                    Text("Add to Today")
                        .font(.subheadline.weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 1)
            )

            Button {
                favorites.toggle(meal.id)
            } label: {
                Image(systemName: favorites.isSaved(meal.id) ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(favorites.isSaved(meal.id) ? Color.pink : .primary)
                    .frame(width: 44, height: 44)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(favorites.isSaved(meal.id) ? "Remove from favorites" : "Add to favorites")
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }

    private var accent: Color {
        switch meal.category.lowercased() {
        case "high protein": return .mint
        case "comfort": return .red
        case "healthy": return .green
        case "quick meal": return .blue
        case "breakfast": return .orange
        case "vegetarian": return .purple
        case "asian": return .indigo
        default: return .secondary
        }
    }

    private var ingredients: [IngredientItem] {
        IngredientItem.seed(for: meal)
    }

    private var shareText: String {
        let ingredientsText = ingredients
            .map { "• \($0.name) — \($0.quantity)" }
            .joined(separator: "\n")

        return """
        \(meal.name) — Meal Prep

        Calories & Macros
        \(meal.calories) kcal • Protein \(meal.protein)g • Carbs \(meal.carbs)g • Fat \(meal.fat)g

        Ingredients
        \(ingredientsText)

        Notes
        \(meal.description)
        """
    }
}

private struct MacroStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct IngredientItem {
    let symbol: String
    let name: String
    let quantity: String

    static func seed(for meal: Meal) -> [IngredientItem] {
        switch meal.id {
        case "oven-baked-salmon-with-lemon":
            return [
                .init(symbol: "fish", name: "Salmon fillet", quantity: "180g"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "sparkles", name: "Lemon", quantity: "1/2"),
                .init(symbol: "leaf", name: "Fresh herbs", quantity: "1 tbsp")
            ]
        case "turkish-style-chicken-saute":
            return [
                .init(symbol: "bird", name: "Chicken breast", quantity: "200g"),
                .init(symbol: "leaf", name: "Bell peppers", quantity: "1 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "circle.grid.cross", name: "Tomatoes", quantity: "1 cup")
            ]
        case "beef-stew-with-vegetables":
            return [
                .init(symbol: "fork.knife", name: "Beef chunks", quantity: "200g"),
                .init(symbol: "leaf", name: "Carrots", quantity: "1 cup"),
                .init(symbol: "circle.grid.cross", name: "Potatoes", quantity: "1 cup"),
                .init(symbol: "drop", name: "Stock", quantity: "1 cup")
            ]
        case "baked-eggplant-with-minced-meat":
            return [
                .init(symbol: "leaf", name: "Eggplant", quantity: "1 large"),
                .init(symbol: "fork.knife", name: "Minced beef", quantity: "180g"),
                .init(symbol: "circle.grid.cross", name: "Tomato sauce", quantity: "1/2 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp")
            ]
        case "creamy-spinach-chicken":
            return [
                .init(symbol: "bird", name: "Chicken breast", quantity: "200g"),
                .init(symbol: "leaf", name: "Spinach", quantity: "2 cups"),
                .init(symbol: "drop", name: "Light cream", quantity: "1/3 cup"),
                .init(symbol: "sparkles", name: "Garlic", quantity: "1 clove")
            ]
        case "oven-roasted-vegetables-with-feta":
            return [
                .init(symbol: "leaf", name: "Mixed vegetables", quantity: "2 cups"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "circle.grid.cross", name: "Feta cheese", quantity: "40g"),
                .init(symbol: "sparkles", name: "Dried herbs", quantity: "1 tsp")
            ]
        case "homemade-chicken-schnitzel":
            return [
                .init(symbol: "bird", name: "Chicken breast", quantity: "200g"),
                .init(symbol: "circle.grid.cross", name: "Breadcrumbs", quantity: "1/2 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "sparkles", name: "Lemon", quantity: "1/2")
            ]
        case "zucchini-boats-with-ground-beef":
            return [
                .init(symbol: "leaf", name: "Zucchini", quantity: "2 medium"),
                .init(symbol: "fork.knife", name: "Ground beef", quantity: "180g"),
                .init(symbol: "circle.grid.cross", name: "Tomato sauce", quantity: "1/2 cup"),
                .init(symbol: "sparkles", name: "Herbs", quantity: "1 tsp")
            ]
        case "rice-pilaf-with-chickpeas":
            return [
                .init(symbol: "takeoutbag.and.cup.and.straw", name: "Rice", quantity: "1 cup"),
                .init(symbol: "leaf", name: "Chickpeas", quantity: "1/2 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "sparkles", name: "Spices", quantity: "1 tsp")
            ]
        case "baked-pasta-with-cheese":
            return [
                .init(symbol: "fork.knife", name: "Pasta", quantity: "90g"),
                .init(symbol: "circle.grid.cross", name: "Cheese blend", quantity: "1/2 cup"),
                .init(symbol: "drop", name: "Tomato sauce", quantity: "1/2 cup"),
                .init(symbol: "sparkles", name: "Herbs", quantity: "1 tsp")
            ]
        case "grilled-chicken-bowl":
            return [
                .init(symbol: "bird", name: "Chicken breast", quantity: "180g"),
                .init(symbol: "leaf", name: "Seasonal veggies", quantity: "1 cup"),
                .init(symbol: "takeoutbag.and.cup.and.straw", name: "Brown rice", quantity: "1 cup"),
                .init(symbol: "avocado", name: "Avocado", quantity: "1/2")
            ]
        case "beef-stir-fry":
            return [
                .init(symbol: "fork.knife", name: "Beef strips", quantity: "200g"),
                .init(symbol: "leaf", name: "Mixed vegetables", quantity: "2 cups"),
                .init(symbol: "drop", name: "Soy sauce", quantity: "1 tbsp"),
                .init(symbol: "sparkles", name: "Garlic", quantity: "1 clove")
            ]
        case "chicken-wrap":
            return [
                .init(symbol: "bird", name: "Grilled chicken", quantity: "150g"),
                .init(symbol: "leaf", name: "Greens", quantity: "1 cup"),
                .init(symbol: "circle.grid.cross", name: "Whole wheat wrap", quantity: "1"),
                .init(symbol: "drop", name: "Yogurt sauce", quantity: "2 tbsp")
            ]
        case "falafel-plate":
            return [
                .init(symbol: "leaf", name: "Falafel", quantity: "4 pieces"),
                .init(symbol: "circle.grid.cross", name: "Pita bread", quantity: "1"),
                .init(symbol: "drop", name: "Hummus", quantity: "3 tbsp"),
                .init(symbol: "leaf", name: "Salad mix", quantity: "1 cup")
            ]
        case "chicken-caesar-salad":
            return [
                .init(symbol: "bird", name: "Grilled chicken", quantity: "150g"),
                .init(symbol: "leaf", name: "Romaine lettuce", quantity: "2 cups"),
                .init(symbol: "circle.grid.cross", name: "Parmesan", quantity: "2 tbsp"),
                .init(symbol: "drop", name: "Caesar dressing", quantity: "2 tbsp")
            ]
        case "tuna-salad-bowl":
            return [
                .init(symbol: "fish", name: "Tuna", quantity: "1 can"),
                .init(symbol: "leaf", name: "Greens", quantity: "2 cups"),
                .init(symbol: "circle.grid.cross", name: "Beans", quantity: "1/2 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp")
            ]
        case "falafel-wrap":
            return [
                .init(symbol: "leaf", name: "Falafel", quantity: "4 pieces"),
                .init(symbol: "circle.grid.cross", name: "Wrap", quantity: "1"),
                .init(symbol: "leaf", name: "Salad mix", quantity: "1 cup"),
                .init(symbol: "drop", name: "Tahini sauce", quantity: "2 tbsp")
            ]
        case "salmon-rice-bowl":
            return [
                .init(symbol: "fish", name: "Salmon", quantity: "160g"),
                .init(symbol: "takeoutbag.and.cup.and.straw", name: "Rice", quantity: "1 cup"),
                .init(symbol: "leaf", name: "Cucumber", quantity: "1/2 cup"),
                .init(symbol: "sparkles", name: "Sesame", quantity: "1 tsp")
            ]
        case "chicken-burrito-bowl":
            return [
                .init(symbol: "bird", name: "Chicken", quantity: "160g"),
                .init(symbol: "takeoutbag.and.cup.and.straw", name: "Rice", quantity: "1 cup"),
                .init(symbol: "circle.grid.cross", name: "Beans", quantity: "1/2 cup"),
                .init(symbol: "leaf", name: "Salsa", quantity: "1/3 cup")
            ]
        case "pasta-tomato-sauce":
            return [
                .init(symbol: "fork.knife", name: "Pasta", quantity: "90g"),
                .init(symbol: "drop", name: "Tomato sauce", quantity: "1/2 cup"),
                .init(symbol: "sparkles", name: "Garlic", quantity: "1 clove"),
                .init(symbol: "leaf", name: "Basil", quantity: "1 tbsp")
            ]
        case "vegetable-pasta":
            return [
                .init(symbol: "fork.knife", name: "Pasta", quantity: "90g"),
                .init(symbol: "leaf", name: "Mixed vegetables", quantity: "1 1/2 cups"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "sparkles", name: "Herbs", quantity: "1 tsp")
            ]
        case "rice-chicken-plate":
            return [
                .init(symbol: "bird", name: "Grilled chicken", quantity: "170g"),
                .init(symbol: "takeoutbag.and.cup.and.straw", name: "Rice", quantity: "1 cup"),
                .init(symbol: "leaf", name: "Vegetables", quantity: "1 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp")
            ]
        case "mushroom-cheese-toast":
            return [
                .init(symbol: "circle.grid.cross", name: "Bread", quantity: "2 slices"),
                .init(symbol: "leaf", name: "Mushrooms", quantity: "1 cup"),
                .init(symbol: "circle.grid.cross", name: "Cheese", quantity: "1/3 cup"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tsp")
            ]
        case "meatball-plate":
            return [
                .init(symbol: "fork.knife", name: "Meatballs", quantity: "5 pieces"),
                .init(symbol: "drop", name: "Tomato sauce", quantity: "1/2 cup"),
                .init(symbol: "leaf", name: "Herbs", quantity: "1 tsp"),
                .init(symbol: "circle.grid.cross", name: "Side greens", quantity: "1 cup")
            ]
        case "creamy-mushroom-pasta":
            return [
                .init(symbol: "fork.knife", name: "Pasta", quantity: "90g"),
                .init(symbol: "leaf", name: "Mushrooms", quantity: "1 cup"),
                .init(symbol: "drop", name: "Cream sauce", quantity: "1/3 cup"),
                .init(symbol: "circle.grid.cross", name: "Parmesan", quantity: "2 tbsp")
            ]
        case "baked-salmon-veggies":
            return [
                .init(symbol: "fish", name: "Salmon", quantity: "170g"),
                .init(symbol: "leaf", name: "Roasted veggies", quantity: "2 cups"),
                .init(symbol: "drop", name: "Olive oil", quantity: "1 tbsp"),
                .init(symbol: "sparkles", name: "Lemon", quantity: "1 wedge")
            ]
        default:
            return [
                .init(symbol: "leaf", name: "Fresh ingredients", quantity: "1 serving"),
                .init(symbol: "drop", name: "Sauce / seasoning", quantity: "to taste"),
                .init(symbol: "fork.knife", name: "Main component", quantity: "1 serving")
            ]
        }
    }
}

#Preview {
    NavigationStack {
        MealDetailView(meal: MockMeals.all[0])
            .environmentObject(FavoritesStore())
            .environmentObject(TodayIntakeStore())
            .environmentObject(ShoppingListStore())
    }
}

