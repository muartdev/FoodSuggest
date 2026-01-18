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
                    ForEach(shopping.items) { item in
                        Button {
                            shopping.toggle(item.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isChecked ? Color.green : .secondary)

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
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: shopping.remove)
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
}

#Preview {
    ShoppingListView()
        .environmentObject(ShoppingListStore())
}

