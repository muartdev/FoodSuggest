import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView("Profile", systemImage: "person", description: Text("Coming soon."))
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}

