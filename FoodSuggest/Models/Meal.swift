import Foundation

struct Meal: Identifiable, Equatable {
    let id: String
    let name: String
    let imageName: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let description: String
    let category: String
}

