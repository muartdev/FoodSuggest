//
//  Meal.swift
//  FoodSuggest
//
//  Created by Murat on 16.01.2026.
//

import Foundation

struct Meal: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let category: String
    let ingredients: [String]
    let instructions: String
}

