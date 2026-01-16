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

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(favoritesStore)
        }
    }
}
