import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var intake: TodayIntakeStore

    var body: some View {
        NavigationStack {
            ScrollView {
                let savedMeals = MockMeals.all.filter { favorites.isSaved($0.id) }

                if savedMeals.isEmpty {
                    ContentUnavailableView(
                        "No favorites yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on a meal to save it here for later.")
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
                    .padding(.horizontal, 16)
                    .padding(.top, 80)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(savedMeals) { meal in
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
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesStore())
        .environmentObject(TodayIntakeStore())
}

