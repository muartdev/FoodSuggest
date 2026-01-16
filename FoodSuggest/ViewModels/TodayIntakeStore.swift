import Foundation
import Combine

@MainActor
final class TodayIntakeStore: ObservableObject {
    struct MacroTargets {
        let carbs: Int
        let protein: Int
        let fat: Int
    }

    let targets = MacroTargets(carbs: 250, protein: 140, fat: 70)

    @Published private(set) var carbsConsumed: Int
    @Published private(set) var proteinConsumed: Int
    @Published private(set) var fatConsumed: Int

    init(carbsConsumed: Int = 120, proteinConsumed: Int = 78, fatConsumed: Int = 46) {
        self.carbsConsumed = carbsConsumed
        self.proteinConsumed = proteinConsumed
        self.fatConsumed = fatConsumed
    }

    func add(meal: Meal) {
        carbsConsumed += meal.carbs
        proteinConsumed += meal.protein
        fatConsumed += meal.fat
    }
}

