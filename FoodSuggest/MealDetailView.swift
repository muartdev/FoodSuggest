import SwiftUI

struct MealDetailView: View {
    let meal: MealSuggestion

    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                hero

                titleBlock

                infoRow

                ingredientsCard

                instructionsCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .background(AppBackgroundView())
        .navigationTitle(meal.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favorites.toggle(meal.id)
                } label: {
                    Image(systemName: favorites.isSaved(meal.id) ? "heart.fill" : "heart")
                        .foregroundStyle(favorites.isSaved(meal.id) ? Color.pink : .primary)
                }
                .accessibilityLabel(favorites.isSaved(meal.id) ? "Remove from favorites" : "Add to favorites")
            }
        }
    }

    private var hero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(.white.opacity(0.14), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 22, x: 0, y: 12)

            ZStack {
                LinearGradient(
                    colors: [
                        meal.accent.opacity(0.25),
                        meal.accent.opacity(0.08),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: meal.heroSymbol)
                    .font(.system(size: 54, weight: .semibold))
                    .foregroundStyle(meal.accent)
                    .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(12)
        }
        .frame(height: 220)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meal.title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(meal.subtitle)
                .foregroundStyle(.secondary)
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

    private var infoRow: some View {
        HStack(spacing: 12) {
            InfoPill(title: "Calories", value: "\(meal.calories)", symbol: "flame")
            InfoPill(title: "Time", value: "\(meal.prepMinutes)m", symbol: "clock")
            InfoPill(title: "Type", value: meal.category, symbol: "tag")
        }
    }

    private var ingredientsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.headline)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(meal.ingredients, id: \.self) { item in
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Circle()
                            .fill(.secondary.opacity(0.35))
                            .frame(width: 6, height: 6)

                        Text(item)
                            .foregroundStyle(.primary)

                        Spacer(minLength: 0)
                    }
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

    private var instructionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1).")
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(width: 22, alignment: .leading)

                        Text(step)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }
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
}

private struct InfoPill: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(value)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 8)
    }
}

#Preview {
    NavigationStack {
        MealDetailView(meal: MockMeals.all[0])
            .environmentObject(FavoritesStore())
    }
}

