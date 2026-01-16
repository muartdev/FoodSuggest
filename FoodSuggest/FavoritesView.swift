import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            ScrollView {
                let savedMeals = MockMeals.all.filter { favorites.isSaved($0.id) }

                if savedMeals.isEmpty {
                    ContentUnavailableView("Favorites", systemImage: "heart", description: Text("Save meals to see them here."))
                        .padding(.top, 80)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(savedMeals) { meal in
                            NavigationLink {
                                MealDetailView(meal: meal)
                            } label: {
                                MealSuggestionCardView(
                                    meal: meal,
                                    isSaved: true,
                                    onToggleSave: { favorites.toggle(meal.id) }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .background(AppBackgroundView())
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesStore())
}

