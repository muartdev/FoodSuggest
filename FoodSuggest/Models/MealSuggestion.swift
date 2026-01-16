import SwiftUI

struct MealSuggestion: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let tag: String
    let category: String
    let calories: Int
    let prepMinutes: Int
    let ingredients: [String]
    let steps: [String]
    let accent: Color
    let symbol: String
    let heroSymbol: String
}

enum MockMeals {
    static let all: [MealSuggestion] = [
        MealSuggestion(
            id: "chicken-salad",
            title: "Chicken Salad",
            subtitle: "Fresh • High protein",
            tag: "Lunch",
            category: "Healthy",
            calories: 420,
            prepMinutes: 15,
            ingredients: ["Chicken breast", "Lettuce", "Tomato", "Cucumber", "Olive oil", "Lemon"],
            steps: [
                "Cook and slice the chicken.",
                "Chop the vegetables.",
                "Toss everything with olive oil and lemon."
            ],
            accent: .mint,
            symbol: "leaf",
            heroSymbol: "bowl"
        ),
        MealSuggestion(
            id: "pasta-pomodoro",
            title: "Pasta Pomodoro",
            subtitle: "Classic • Comfort food",
            tag: "Dinner",
            category: "Italian",
            calories: 650,
            prepMinutes: 25,
            ingredients: ["Pasta", "Tomatoes", "Garlic", "Olive oil", "Basil", "Salt"],
            steps: [
                "Boil pasta until al dente.",
                "Simmer tomatoes with garlic and olive oil.",
                "Combine pasta with sauce and finish with basil."
            ],
            accent: .red,
            symbol: "fork.knife",
            heroSymbol: "fork.knife.circle"
        ),
        MealSuggestion(
            id: "oatmeal-bowl",
            title: "Oatmeal Bowl",
            subtitle: "Quick • Energizing",
            tag: "Breakfast",
            category: "Breakfast",
            calories: 380,
            prepMinutes: 8,
            ingredients: ["Oats", "Milk or water", "Banana", "Honey", "Cinnamon"],
            steps: [
                "Cook oats with milk or water.",
                "Top with banana, honey, and cinnamon."
            ],
            accent: .orange,
            symbol: "sunrise",
            heroSymbol: "sun.max"
        ),
        MealSuggestion(
            id: "yogurt-parfait",
            title: "Greek Yogurt Parfait",
            subtitle: "Light • Sweet",
            tag: "Snack",
            category: "Snack",
            calories: 290,
            prepMinutes: 5,
            ingredients: ["Greek yogurt", "Berries", "Granola", "Honey"],
            steps: [
                "Spoon yogurt into a bowl.",
                "Add berries and granola.",
                "Drizzle honey on top."
            ],
            accent: .purple,
            symbol: "sparkles",
            heroSymbol: "sparkles.rectangle.stack"
        )
    ]
}

