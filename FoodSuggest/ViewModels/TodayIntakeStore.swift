import Foundation
import Combine

@MainActor
final class TodayIntakeStore: ObservableObject {
    struct MealEntry: Identifiable, Codable, Equatable {
        let id: UUID
        let mealID: String
        let mealName: String
        let calories: Int
        let carbs: Int
        let protein: Int
        let fat: Int
        let timestamp: Date

        init(
            id: UUID = UUID(),
            mealID: String,
            mealName: String,
            calories: Int,
            carbs: Int,
            protein: Int,
            fat: Int,
            timestamp: Date = Date()
        ) {
            self.id = id
            self.mealID = mealID
            self.mealName = mealName
            self.calories = calories
            self.carbs = carbs
            self.protein = protein
            self.fat = fat
            self.timestamp = timestamp
        }
    }

    struct MacroTargets {
        let carbs: Int
        let protein: Int
        let fat: Int
    }

    let targets = MacroTargets(carbs: 250, protein: 140, fat: 70)

    @Published private(set) var carbsConsumed: Int
    @Published private(set) var proteinConsumed: Int
    @Published private(set) var fatConsumed: Int
    @Published private(set) var entries: [MealEntry] = [] {
        didSet { persist() }
    }

    private let storageKey = "today_intake_entries_v1"
    private let calendar = Calendar.current

    init(carbsConsumed: Int = 120, proteinConsumed: Int = 78, fatConsumed: Int = 46) {
        self.carbsConsumed = carbsConsumed
        self.proteinConsumed = proteinConsumed
        self.fatConsumed = fatConsumed
        load()
        recalculateTodayTotals()
    }

    func add(meal: Meal) {
        entries.append(
            MealEntry(
                mealID: meal.id,
                mealName: meal.name,
                calories: meal.calories,
                carbs: meal.carbs,
                protein: meal.protein,
                fat: meal.fat
            )
        )
        recalculateTodayTotals()
    }

    func dailySummaries(limitDays: Int = 7) -> [DailySummary] {
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.timestamp)
        }

        let days = grouped.keys.sorted(by: >).prefix(limitDays)
        return days.map { day in
            let dayEntries = (grouped[day] ?? []).sorted(by: { $0.timestamp > $1.timestamp })
            let totalCalories = dayEntries.reduce(0) { $0 + $1.calories }
            return DailySummary(date: day, totalCalories: totalCalories, meals: dayEntries)
        }
    }

    struct DailySummary: Identifiable, Equatable {
        var id: Date { date }
        let date: Date
        let totalCalories: Int
        let meals: [MealEntry]
    }

    private func recalculateTodayTotals() {
        let todayEntries = entries.filter { calendar.isDateInToday($0.timestamp) }
        carbsConsumed = todayEntries.reduce(0) { $0 + $1.carbs }
        proteinConsumed = todayEntries.reduce(0) { $0 + $1.protein }
        fatConsumed = todayEntries.reduce(0) { $0 + $1.fat }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([MealEntry].self, from: data)
        else { return }
        entries = decoded
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

