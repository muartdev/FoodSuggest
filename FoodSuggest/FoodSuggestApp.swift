//
//  FoodSuggestApp.swift
//  FoodSuggest
//
//  Created by Murat on 16.01.2026.
//

import SwiftUI

@main
struct FoodSuggestApp: App {
    @StateObject private var favoritesStore = FavoritesStore()
    @StateObject private var intakeStore = TodayIntakeStore()
    @StateObject private var shoppingStore = ShoppingListStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(favoritesStore)
                .environmentObject(intakeStore)
                .environmentObject(shoppingStore)
        }
    }
}
