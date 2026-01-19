import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            ScrollView {
                let savedMeals = MockMeals.all.filter { favorites.isSaved($0.id) }

                if savedMeals.isEmpty {
                    ContentUnavailableView(
                        "No favorites yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on a meal to save it here for later.")
                    )
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.14), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 12)
                    .padding(.horizontal, 16)
                    .padding(.top, 80)
                } else {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        FavoritesSection(title: "Breakfast", meals: savedMeals.filter { $0.category == "Breakfast" })
                        FavoritesSection(title: "Lunch", meals: savedMeals.filter { $0.category == "Lunch" })
                        FavoritesSection(title: "Dinner", meals: savedMeals.filter { $0.category == "Dinner" })
                        FavoritesSection(title: "Snacks", meals: savedMeals.filter { $0.category == "Snack" || $0.category == "Dessert" })
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct FavoritesSection: View {
    let title: String
    let meals: [Meal]

    var body: some View {
        if !meals.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                LazyVStack(spacing: 10) {
                    ForEach(meals) { meal in
                        NavigationLink {
                            MealDetailView(meal: meal)
                        } label: {
                            FavoriteMealCard(meal: meal)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

private struct FavoriteMealCard: View {
    let meal: Meal

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(meal.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer(minLength: 0)

            Text("\(meal.calories) kcal")
                .font(.caption)
                .foregroundStyle(.secondary)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesStore())
        .environmentObject(TodayIntakeStore())
        .environmentObject(ShoppingListStore())
}

