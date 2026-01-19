import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct CategoryMealsView: View {
    let category: MealCategory

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(category.rawValue)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text("Tap a meal to see details.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(meals) { meal in
                        NavigationLink {
                            MealDetailView(meal: meal)
                        } label: {
                            MealVisualCard(
                                meal: meal,
                                imageName: meal.imageAsset
                            )
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

    private var meals: [Meal] {
        MockMeals.all.filter { $0.category == category.filterKey }
    }

}

private struct MealVisualCard: View {
    let meal: Meal
    let imageName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AssetPhoto(name: imageName)
                .frame(height: 120)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.10)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(meal.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(meal.calories) kcal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct AssetPhoto: View {
    let name: String?

    var body: some View {
#if canImport(UIKit)
        if let name, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            LinearGradient(
                colors: [Color.white.opacity(0.28), Color.white.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
#else
        LinearGradient(
            colors: [Color.white.opacity(0.28), Color.white.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
#endif
    }
}

#Preview {
    NavigationStack {
        CategoryMealsView(category: .breakfast)
            .environmentObject(FavoritesStore())
            .environmentObject(TodayIntakeStore())
            .environmentObject(ShoppingListStore())
    }
}

