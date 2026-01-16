import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    LazyVStack(spacing: 14) {
                        ForEach(MockMeals.all) { meal in
                            NavigationLink {
                                MealDetailView(meal: meal)
                            } label: {
                                MealSuggestionCardView(
                                    meal: meal,
                                    isSaved: favorites.isSaved(meal.id),
                                    onToggleSave: { favorites.toggle(meal.id) }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(AppBackgroundView())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Meal suggestions")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Pick something good in seconds.")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
    }
}

#Preview {
    MainTabView()
        .environmentObject(FavoritesStore())
}

