import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var intake: TodayIntakeStore
    @State private var selectedCategory: String = "All"
    @State private var todaysPickID: Meal.ID?

    private let categories: [String] = ["All", "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
    private let sectionSpacing: CGFloat = 10

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: sectionSpacing) {
                    todaysPickSection
                    categoryFilter

                    Group {
                        if filteredMeals.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(filteredMeals) { meal in
                                    NavigationLink {
                                        MealDetailView(meal: meal)
                                    } label: {
                                        MealCompactCardView(
                                            meal: meal,
                                            isSaved: favorites.isSaved(meal.id),
                                            onToggleSave: { favorites.toggle(meal.id) },
                                            onQuickAdd: { intake.add(meal: meal) }
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.20), value: selectedCategory)
                }
                .padding(.horizontal, 16)
                .padding(.top, 2)
                .padding(.bottom, 24)
            }
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if todaysPickID == nil {
                todaysPickID = MockMeals.all.randomElement()?.id
            }
        }
    }

    private var filteredMeals: [Meal] {
        if selectedCategory == "All" {
            return MockMeals.all
        } else {
            return MockMeals.all.filter { $0.category == selectedCategory }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No meals found",
            systemImage: "sparkles.magnifyingglass",
            description: Text(emptyStateMessage)
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
    }

    private var emptyStateMessage: String {
        return "Try another category—your next favorite could be one tap away."
    }

    private var todaysPickMeal: Meal? {
        guard let id = todaysPickID else { return nil }
        return MockMeals.all.first(where: { $0.id == id })
    }

    private var todaysPickSection: some View {
        Group {
            if let meal = todaysPickMeal {
                NavigationLink {
                    MealDetailView(meal: meal)
                } label: {
                    TodaysPickCard(meal: meal)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        withAnimation(.easeInOut(duration: 0.20)) {
                            selectedCategory = category
                        }
                    } label: {
                        Text(category)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(selectedCategory == category ? .primary : .secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(
                                        selectedCategory == category ? Color.primary.opacity(0.22) : Color.white.opacity(0.14),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
            .animation(.easeInOut(duration: 0.20), value: selectedCategory)
        }
    }

}

private struct TodaysPickCard: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(accent.opacity(0.18))

                Image(systemName: meal.imageName)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(accent)
            }
            .frame(width: 92, height: 92)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Today’s Pick")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.thinMaterial)
                        .clipShape(Capsule())

                    Spacer(minLength: 0)
                }

                Text(meal.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(meal.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.10), radius: 22, x: 0, y: 14)
    }

    private var accent: Color {
        switch meal.category.lowercased() {
        case "breakfast": return .orange
        case "lunch": return .mint
        case "dinner": return .red
        case "snack": return .purple
        case "dessert": return .pink
        default: return .secondary
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FavoritesStore())
        .environmentObject(TodayIntakeStore())
}

