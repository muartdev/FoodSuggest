import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var intake: TodayIntakeStore
    @State private var selectedCategory: String = "All"
    @State private var todaysPickID: Meal.ID?
    @State private var searchText: String = ""

    private let categories: [String] = ["All", "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
    private let sectionSpacing: CGFloat = 14

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: sectionSpacing) {
                    categoryFilter
                    todaysPickSection
                    todaysMacrosSection

                    Group {
                        if filteredMeals.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 14) {
                                ForEach(filteredMeals) { meal in
                                    NavigationLink {
                                        MealDetailView(meal: meal)
                                    } label: {
                                        MealSuggestionCardView(
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
                    .animation(.easeInOut(duration: 0.15), value: searchText)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 24)
            }
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "Search meals")
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            if todaysPickID == nil {
                todaysPickID = MockMeals.all.randomElement()?.id
            }
        }
    }

    private var filteredMeals: [Meal] {
        let base: [Meal]
        if selectedCategory == "All" {
            base = MockMeals.all
        } else {
            base = MockMeals.all.filter { $0.category == selectedCategory }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return base }

        return base.filter { $0.name.localizedCaseInsensitiveContains(query) }
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
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            return "Try a different name or clear the search to explore more meals."
        }
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

    private var todaysMacrosSection: some View {
        Button {
            // Future: open a detailed macros view
        } label: {
            TodaysMacrosMiniCard(
                carbs: (consumed: intake.carbsConsumed, target: intake.targets.carbs, color: Color.blue.opacity(0.55)),
                protein: (consumed: intake.proteinConsumed, target: intake.targets.protein, color: Color.mint.opacity(0.60)),
                fat: (consumed: intake.fatConsumed, target: intake.targets.fat, color: Color.orange.opacity(0.55))
            )
        }
        .buttonStyle(.plain)
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

private struct TodaysMacrosMiniCard: View {
    let carbs: (consumed: Int, target: Int, color: Color)
    let protein: (consumed: Int, target: Int, color: Color)
    let fat: (consumed: Int, target: Int, color: Color)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MiniMacroBar(consumed: carbs.consumed, target: carbs.target, color: carbs.color)
            MiniMacroBar(consumed: protein.consumed, target: protein.target, color: protein.color)
            MiniMacroBar(consumed: fat.consumed, target: fat.target, color: fat.color)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 6)
    }
}

private struct MiniMacroBar: View {
    let consumed: Int
    let target: Int
    let color: Color

    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(Double(consumed) / Double(target), 1)
    }

    var body: some View {
        ProgressView(value: progress)
            .tint(color)
            .background(Color.primary.opacity(0.05))
            .clipShape(Capsule())
            .frame(height: 5)
    }
}

#Preview {
    MainTabView()
        .environmentObject(FavoritesStore())
        .environmentObject(TodayIntakeStore())
}

