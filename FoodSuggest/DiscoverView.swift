import SwiftUI

struct DiscoverView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView("Discover", systemImage: "magnifyingglass", description: Text("Coming soon."))
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DiscoverView()
}

