import SwiftUI
import Foundation

struct MainTabView: View {
    private var isRunningForPreviews: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    var body: some View {
        if isRunningForPreviews {
            previewFallback
        } else {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }

                ShoppingListView()
                    .tabItem {
                        Image(systemName: "cart.fill")
                        Text("Shopping")
                    }

                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
        }
    }

    private var previewFallback: some View {
        NavigationStack {
            List {
                NavigationLink("Home") { HomeView() }
                NavigationLink("Favorites") { FavoritesView() }
                NavigationLink("Shopping") { ShoppingListView() }
                NavigationLink("Profile") { ProfileView() }
            }
            .navigationTitle("Previews")
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(FavoritesStore())
        .environmentObject(TodayIntakeStore())
        .environmentObject(ShoppingListStore())
        .environmentObject(SettingsStore())
}
