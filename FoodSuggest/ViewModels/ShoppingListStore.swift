import Foundation
import Combine

@MainActor
final class ShoppingListStore: ObservableObject {
    struct Item: Identifiable, Codable, Equatable {
        let id: UUID
        var name: String
        var quantity: String
        var isChecked: Bool
        var sourceMeal: String?

        init(id: UUID = UUID(), name: String, quantity: String, isChecked: Bool = false, sourceMeal: String? = nil) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.isChecked = isChecked
            self.sourceMeal = sourceMeal
        }
    }

    @Published var items: [Item] = [] {
        didSet { persist() }
    }

    private let storageKeyV2 = "shopping_list_items_v2"
    private let storageKeyV1 = "shopping_list_items_v1"

    init() {
        load()
    }

    func add(name: String, quantity: String, sourceMeal: String?) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let sourceKey = (sourceMeal ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // Merge by (sourceMeal + name). If quantity differs, keep the latest.
        if let idx = items.firstIndex(where: {
            $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame
            && ($0.sourceMeal ?? "").localizedCaseInsensitiveCompare(sourceKey) == .orderedSame
        }) {
            items[idx].quantity = quantity
            items[idx].isChecked = false
        } else {
            items.append(.init(name: trimmed, quantity: quantity, sourceMeal: sourceKey.isEmpty ? nil : sourceKey))
        }
    }

    func addAll(_ entries: [(name: String, quantity: String)], sourceMeal: String?) {
        for e in entries {
            add(name: e.name, quantity: e.quantity, sourceMeal: sourceMeal)
        }
    }

    func toggle(_ id: UUID) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].isChecked.toggle()
    }

    func remove(id: UUID) {
        items.removeAll(where: { $0.id == id })
    }

    func remove(at offsets: IndexSet) {
        // Avoid SwiftUI dependency (`remove(atOffsets:)` lives in SwiftUI)
        for i in offsets.sorted(by: >) {
            if items.indices.contains(i) {
                items.remove(at: i)
            }
        }
    }

    func clear() {
        items.removeAll()
    }

    private func load() {
        let decoder = JSONDecoder()

        if
            let data = UserDefaults.standard.data(forKey: storageKeyV2),
            let decoded = try? decoder.decode([Item].self, from: data)
        {
            items = decoded
            return
        }

        // Backward compatibility (v1 had no `sourceMeal`)
        if
            let data = UserDefaults.standard.data(forKey: storageKeyV1),
            let decoded = try? decoder.decode([Item].self, from: data)
        {
            items = decoded
            persist()
        }
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKeyV2)
    }
}

