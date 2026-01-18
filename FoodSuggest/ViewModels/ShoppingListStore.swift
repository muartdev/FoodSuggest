import Foundation

@MainActor
final class ShoppingListStore: ObservableObject {
    struct Item: Identifiable, Codable, Equatable {
        let id: UUID
        var name: String
        var quantity: String
        var isChecked: Bool

        init(id: UUID = UUID(), name: String, quantity: String, isChecked: Bool = false) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.isChecked = isChecked
        }
    }

    @Published var items: [Item] = [] {
        didSet { persist() }
    }

    private let storageKey = "shopping_list_items_v1"

    init() {
        load()
    }

    func add(name: String, quantity: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // Merge by name (case-insensitive). If quantity differs, keep the latest.
        if let idx = items.firstIndex(where: { $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame }) {
            items[idx].quantity = quantity
            items[idx].isChecked = false
        } else {
            items.append(.init(name: trimmed, quantity: quantity))
        }
    }

    func addAll(_ entries: [(name: String, quantity: String)]) {
        for e in entries {
            add(name: e.name, quantity: e.quantity)
        }
    }

    func toggle(_ id: UUID) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].isChecked.toggle()
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func clear() {
        items.removeAll()
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([Item].self, from: data)
        else { return }
        items = decoded
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

