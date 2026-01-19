import Foundation
import Combine
import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    enum Theme: String, CaseIterable, Identifiable {
        case system
        case light
        case dark

        var id: String { rawValue }

        var title: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }

        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }

    enum Language: String, CaseIterable, Identifiable {
        case system
        case en
        case tr

        var id: String { rawValue }

        var title: String {
            switch self {
            case .system: return "System"
            case .en: return "English"
            case .tr: return "Türkçe"
            }
        }

        var locale: Locale? {
            switch self {
            case .system: return nil
            case .en: return Locale(identifier: "en")
            case .tr: return Locale(identifier: "tr")
            }
        }
    }

    @AppStorage("settings_theme") var themeRaw: String = Theme.system.rawValue
    @AppStorage("settings_language") var languageRaw: String = Language.system.rawValue

    var theme: Theme {
        get { Theme(rawValue: themeRaw) ?? .system }
        set { themeRaw = newValue.rawValue }
    }

    var language: Language {
        get { Language(rawValue: languageRaw) ?? .system }
        set { languageRaw = newValue.rawValue }
    }
}

