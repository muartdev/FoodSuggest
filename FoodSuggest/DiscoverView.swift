import SwiftUI

struct DiscoverView: View {
    @State private var selectedCategory: String = "All"
    @State private var todaysPickID: Meal.ID?

    private let categories: [String] = ["All", "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    discoverHeroCard
                        .padding(.top, 2)

                    if let meal = todaysPickMeal {
                        NavigationLink {
                            MealDetailView(meal: meal)
                        } label: {
                            TodaysPickCompactCard(meal: meal)
                        }
                        .buttonStyle(.plain)
                    }

                    categoryFilter

                    LazyVStack(spacing: 10) {
                        ForEach(filteredMeals) { meal in
                            NavigationLink {
                                MealDetailView(meal: meal)
                            } label: {
                                DiscoverMealRow(meal: meal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
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

    private var discoverHeroCard: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.thinMaterial)

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text("Discover")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Browse and explore recipes")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 12)
    }

    private var todaysPickMeal: Meal? {
        guard let id = todaysPickID else { return nil }
        return MockMeals.all.first(where: { $0.id == id })
    }

    private var filteredMeals: [Meal] {
        if selectedCategory == "All" {
            return MockMeals.all
        } else {
            return MockMeals.all.filter { $0.category == selectedCategory }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selectedCategory = category
                        }
                    } label: {
                        Text(category)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(selectedCategory == category ? .primary : .secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.thinMaterial)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(
                                        selectedCategory == category ? Color.primary.opacity(0.18) : Color.white.opacity(0.10),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private struct TodaysPickCompactCard: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today’s Pick")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(meal.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("\(meal.calories) kcal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 10)
    }
}

private struct DiscoverMealRow: View {
    let meal: Meal

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(meal.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Text("\(meal.calories) kcal")
                .font(.caption)
                .foregroundStyle(.secondary)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    DiscoverView()
}

