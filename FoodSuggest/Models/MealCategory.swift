import Foundation

enum MealCategory: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"

    var id: String { rawValue }

    /// Label shown on the Home grid.
    var homeTitle: String {
        switch self {
        case .snack: return "Snacks"
        default: return rawValue
        }
    }

    /// Value used for filtering `Meal.category`.
    var filterKey: String { rawValue }
}

