import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Picker("Theme", selection: Binding(
                        get: { settings.theme },
                        set: { settings.theme = $0 }
                    )) {
                        ForEach(SettingsStore.Theme.allCases) { theme in
                            Text(theme.title).tag(theme)
                        }
                    }
                }

                Section("Language") {
                    Picker("App language", selection: Binding(
                        get: { settings.language },
                        set: { settings.language = $0 }
                    )) {
                        ForEach(SettingsStore.Language.allCases) { lang in
                            Text(lang.title).tag(lang)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsStore())
}

