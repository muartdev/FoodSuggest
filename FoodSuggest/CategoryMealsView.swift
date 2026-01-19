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

                if category == .breakfast {
                    BreakfastIdeasSection()
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(meals) { meal in
                            NavigationLink {
                                MealDetailView(meal: meal)
                            } label: {
                                MealVisualCard(meal: meal)
                            }
                            .buttonStyle(.plain)
                        }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Rectangle()
                .fill(LinearGradient(colors: [Color.white.opacity(0.28), Color.white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.10)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .frame(height: 92)

            Text(meal.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text("\(meal.calories) kcal")
                .font(.caption)
                .foregroundStyle(.secondary)
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

private struct BreakfastIdeasSection: View {
    private let ideas = BreakfastIdea.samples

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Breakfast ideas")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(ideas) { idea in
                    if let mealID = idea.mealID,
                       let meal = MockMeals.all.first(where: { $0.id == mealID }) {
                        NavigationLink {
                            MealDetailView(meal: meal)
                        } label: {
                            IdeaImageCard(assetName: idea.assetName, title: idea.title)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink {
                            BreakfastIdeaDetailView(idea: idea)
                        } label: {
                            IdeaImageCard(assetName: idea.assetName, title: idea.title)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

private struct IdeaImageCard: View {
    let assetName: String
    let title: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AssetPhoto(name: assetName)
                .overlay(
                    LinearGradient(
                        colors: [Color.black.opacity(0.00), Color.black.opacity(0.22)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 10)
    }
}

private struct BreakfastIdea: Identifiable {
    let id = UUID()
    let title: String
    let assetName: String
    let mealID: String?

    static let samples: [BreakfastIdea] = [
        .init(title: "Scrambled Eggs with Spinach", assetName: "bfast_01_scramble", mealID: nil),
        .init(title: "Pancakes with Berries", assetName: "bfast_02_pancakes", mealID: nil),
        .init(title: "Breakfast Plate", assetName: "bfast_03_eggs_sausage", mealID: nil),
        .init(title: "Peanut Butter Banana Toast", assetName: "bfast_04_banana_toast", mealID: nil),
        .init(title: "Avocado Egg Toast", assetName: "bfast_05_avocado_egg", mealID: "avocado-egg-toast"),
        .init(title: "Avocado Toast", assetName: "bfast_13_avocado_toast", mealID: nil),
        .init(title: "Granola Bowl with Yogurt", assetName: "bfast_06_granola_bowl", mealID: "fruit-yogurt-cup"),
        .init(title: "Greek Yogurt Bowl", assetName: "bfast_07_yogurt_nuts", mealID: "fruit-yogurt-cup"),
        .init(title: "Chia Pudding", assetName: "bfast_08_chia_pudding", mealID: nil),
        .init(title: "Oatmeal with Fruits", assetName: "bfast_09_oatmeal", mealID: "oatmeal-with-fruits"),
        .init(title: "French Toast", assetName: "bfast_10_french_toast", mealID: nil),
        .init(title: "Yogurt Bowl", assetName: "bfast_11_yogurt_swirl", mealID: "fruit-yogurt-cup"),
        .init(title: "Menemen", assetName: "bfast_12_shakshuka", mealID: nil)
    ]
}

private struct BreakfastIdeaDetailView: View {
    let idea: BreakfastIdea

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AssetPhoto(name: idea.assetName)
                    .overlay(
                        LinearGradient(
                            colors: [Color.black.opacity(0.00), Color.black.opacity(0.18)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                Text(idea.title)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)

                Text("This breakfast idea is coming soon. Tap other items to view full details.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(AppBackgroundView())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AssetPhoto: View {
    let name: String

    var body: some View {
#if canImport(UIKit)
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            // Nice neutral placeholder if asset not added yet
            LinearGradient(
                colors: [Color.white.opacity(0.30), Color.white.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
#else
        LinearGradient(
            colors: [Color.white.opacity(0.30), Color.white.opacity(0.08)],
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

