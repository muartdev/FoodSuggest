import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    heroTitle
                        .padding(.top, 10)

                    categoryGrid

                    todaysPlanCard
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var heroTitle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What are you eating today?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)

            Text("Choose a category to get inspired.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var categoryGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            CategoryCard(
                title: MealCategory.breakfast.homeTitle,
                imageName: "cat_breakfast",
                theme: .breakfast,
                destination: CategoryMealsView(category: .breakfast)
            )
            CategoryCard(
                title: MealCategory.lunch.homeTitle,
                imageName: "cat_lunch",
                theme: .lunch,
                destination: CategoryMealsView(category: .lunch)
            )
            CategoryCard(
                title: MealCategory.dinner.homeTitle,
                imageName: "cat_dinner",
                theme: .dinner,
                destination: CategoryMealsView(category: .dinner)
            )
            CategoryCard(
                title: MealCategory.snack.homeTitle,
                imageName: "cat_snacks",
                theme: .snack,
                destination: CategoryMealsView(category: .snack)
            )
        }
    }

    private var todaysPlanCard: some View {
        let breakfast = 400
        let lunch = 600
        let dinner = 700
        let total = breakfast + lunch + dinner

        return VStack(alignment: .leading, spacing: 10) {
            Text("Today’s balanced plan")
                .font(.headline)
                .foregroundStyle(.primary)

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Breakfast")
                    Text("Lunch")
                    Text("Dinner")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 6) {
                    Text("\(breakfast) kcal")
                    Text("\(lunch) kcal")
                    Text("\(dinner) kcal")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            }

            Divider().opacity(0.6)

            HStack {
                Text("Total")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
                Text("\(total) kcal")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
        }
        .padding(16)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private enum CategoryTheme {
    case breakfast
    case lunch
    case dinner
    case snack

    var gradient: LinearGradient {
        switch self {
        case .breakfast:
            return LinearGradient(colors: [Color.orange.opacity(0.75), Color.pink.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .lunch:
            return LinearGradient(colors: [Color.mint.opacity(0.65), Color.blue.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .dinner:
            return LinearGradient(colors: [Color.indigo.opacity(0.70), Color.purple.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .snack:
            return LinearGradient(colors: [Color.yellow.opacity(0.55), Color.orange.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

private struct CategoryCard<Destination: View>: View {
    let title: String
    let imageName: String
    let theme: CategoryTheme
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            ZStack(alignment: .bottomLeading) {
                AssetPhoto(name: imageName, fallback: theme.gradient)
                    .overlay(
                        LinearGradient(
                            colors: [Color.black.opacity(0.00), Color.black.opacity(0.30)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(12)
            }
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct AssetPhoto<Fallback: View>: View {
    let name: String
    let fallback: Fallback

    var body: some View {
#if canImport(UIKit)
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            fallback
        }
#else
        fallback
#endif
    }
}

#Preview {
    HomeView()
}

