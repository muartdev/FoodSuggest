import SwiftUI

struct MealDetailView: View {
    let meal: Meal

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
        .navigationTitle(meal.name)
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
                        accent.opacity(0.25),
                        accent.opacity(0.08),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: meal.imageName)
                    .font(.system(size: 54, weight: .semibold))
                    .foregroundStyle(accent)
                    .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(12)
        }
        .frame(height: 220)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meal.name)
                .font(.title2)
                .fontWeight(.semibold)

            Text(meal.description)
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
            InfoPill(title: "Protein", value: "\(meal.protein)g", symbol: "circle.grid.cross")
            InfoPill(title: "Type", value: meal.category, symbol: "tag")
        }
    }

    private var ingredientsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Macros")
                .font(.headline)

            VStack(alignment: .leading, spacing: 10) {
                macroRow(label: "Carbs", value: "\(meal.carbs)g")
                macroRow(label: "Fat", value: "\(meal.fat)g")
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
            Text("About")
                .font(.headline)

            Text(meal.description)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
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

    private func macroRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .font(.subheadline)
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

