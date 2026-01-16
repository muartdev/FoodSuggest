import SwiftUI

struct MealDetailView: View {
    let meal: Meal

    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var intake: TodayIntakeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                hero

                titleSection

                macrosCard

                ingredientsCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(AppBackgroundView())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            bottomActions
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

    private var macrosCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Macros")
                    .font(.headline)
                Spacer(minLength: 0)
            }

            MacroProgressRow(label: "Carbs", value: meal.carbs, target: intake.targets.carbs, color: Color.blue.opacity(0.70))
            MacroProgressRow(label: "Protein", value: meal.protein, target: intake.targets.protein, color: Color.mint.opacity(0.80))
            MacroProgressRow(label: "Fat", value: meal.fat, target: intake.targets.fat, color: Color.orange.opacity(0.75))
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
            Text("Macros")
                .font(.headline)

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
}

private struct MacroProgressRow: View {
    let label: String
    let value: Int
    let target: Int
    let color: Color

    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(Double(value) / Double(target), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                Text("\(value)g")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(color)
                .background(Color.primary.opacity(0.06))
                .clipShape(Capsule())
                .frame(height: 8)
        }
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
    }
}

