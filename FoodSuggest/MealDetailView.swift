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
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)

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
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
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
        case "grilled-chicken-bowl":
            return [
                .init(symbol: "bird", name: "Chicken breast", quantity: "180g"),
                .init(symbol: "leaf", name: "Seasonal veggies", quantity: "1 cup"),
                .init(symbol: "takeoutbag.and.cup.and.straw", name: "Brown rice", quantity: "1 cup"),
                .init(symbol: "avocado", name: "Avocado", quantity: "1/2")
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

