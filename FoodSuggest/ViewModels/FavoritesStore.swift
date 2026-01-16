import Foundation
import Combine

@MainActor
final class FavoritesStore: ObservableObject {
    private static let storageKey = "savedMealIDs"

    @Published private(set) var savedMealIDs: Set<String> = []

    init() {
        load()
    }

    func isSaved(_ id: String) -> Bool {
        savedMealIDs.contains(id)
    }

    func toggle(_ id: String) {
        if savedMealIDs.contains(id) {
            savedMealIDs.remove(id)
        } else {
            savedMealIDs.insert(id)
        }
        save()
    }

    private func load() {
        let ids = UserDefaults.standard.array(forKey: Self.storageKey) as? [String] ?? []
        savedMealIDs = Set(ids)
    }

    private func save() {
        UserDefaults.standard.set(Array(savedMealIDs).sorted(), forKey: Self.storageKey)
    }
}

