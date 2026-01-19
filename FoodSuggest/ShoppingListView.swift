import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject private var shopping: ShoppingListStore

    var body: some View {
        NavigationStack {
            List {
                if shopping.items.isEmpty {
                    ContentUnavailableView(
                        "Shopping list is empty",
                        systemImage: "cart",
                        description: Text("Open a meal and add its ingredients here.")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(groupedSections, id: \.title) { section in
                        Section(section.title) {
                            ForEach(section.items) { item in
                                HStack(spacing: 12) {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(item.isChecked ? Color.green : .secondary)
                                        .onTapGesture { shopping.toggle(item.id) }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .foregroundStyle(.primary)

                                        if !item.quantity.isEmpty {
                                            Text(item.quantity)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }

                                    Spacer(minLength: 0)

                                    Button(role: .destructive) {
                                        shopping.remove(id: item.id)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.borderless)
                                    .accessibilityLabel("Delete item")
                                }
                                .contentShape(Rectangle())
                                .onTapGesture { shopping.toggle(item.id) }
                            }
                            .onDelete(perform: shopping.remove)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        shopping.clear()
                    }
                    .disabled(shopping.items.isEmpty)
                }
            }
        }
    }

    private struct GroupedSection {
        let title: String
        let items: [ShoppingListStore.Item]
    }

    private var groupedSections: [GroupedSection] {
        let grouped = Dictionary(grouping: shopping.items) { item in
            (item.sourceMeal?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 }
        }

        let mealTitles = grouped.keys.compactMap { $0 }.sorted()
        var sections: [GroupedSection] = mealTitles.map { title in
            GroupedSection(title: title, items: grouped[title]?.sorted(by: { $0.name < $1.name }) ?? [])
        }

        if let otherItems = grouped[nil], !otherItems.isEmpty {
            sections.append(GroupedSection(title: "Other", items: otherItems.sorted(by: { $0.name < $1.name })))
        }

        return sections
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(ShoppingListStore())
}

