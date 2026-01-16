import Foundation

enum MockMeals {
    static let all: [Meal] = [
        Meal(
            id: "grilled-chicken-bowl",
            name: "Grilled Chicken Bowl",
            imageName: "bowl",
            calories: 520,
            protein: 42,
            carbs: 48,
            fat: 18,
            description: "Grilled chicken breast served with brown rice, avocado, and seasonal vegetables. High-protein and balanced.",
            category: "Lunch"
        ),
        Meal(
            id: "creamy-mushroom-pasta",
            name: "Creamy Mushroom Pasta",
            imageName: "fork.knife",
            calories: 610,
            protein: 18,
            carbs: 72,
            fat: 24,
            description: "Pasta with creamy mushroom sauce, garlic, and parmesan cheese. Comfort food with rich flavor.",
            category: "Dinner"
        ),
        Meal(
            id: "baked-salmon-veggies",
            name: "Baked Salmon & Veggies",
            imageName: "fish",
            calories: 480,
            protein: 38,
            carbs: 32,
            fat: 22,
            description: "Oven-baked salmon with olive oil roasted vegetables. Rich in omega-3.",
            category: "Dinner"
        ),
        Meal(
            id: "chicken-wrap",
            name: "Chicken Wrap",
            imageName: "tortilla",
            calories: 450,
            protein: 30,
            carbs: 40,
            fat: 16,
            description: "Whole wheat wrap with grilled chicken, yogurt sauce, and fresh greens.",
            category: "Lunch"
        ),
        Meal(
            id: "avocado-egg-toast",
            name: "Avocado Egg Toast",
            imageName: "takeoutbag.and.cup.and.straw",
            calories: 390,
            protein: 16,
            carbs: 34,
            fat: 20,
            description: "Toasted sourdough bread topped with smashed avocado and poached eggs.",
            category: "Breakfast"
        ),
        Meal(
            id: "lentil-curry",
            name: "Lentil Curry",
            imageName: "leaf",
            calories: 430,
            protein: 22,
            carbs: 58,
            fat: 12,
            description: "Spiced red lentil curry cooked with coconut milk and herbs.",
            category: "Dinner"
        ),
        Meal(
            id: "homemade-beef-burger",
            name: "Homemade Beef Burger",
            imageName: "takeoutbag.and.cup.and.straw",
            calories: 680,
            protein: 36,
            carbs: 45,
            fat: 38,
            description: "Juicy beef patty with cheddar cheese and homemade sauce.",
            category: "Dinner"
        ),
        Meal(
            id: "falafel-plate",
            name: "Falafel Plate",
            imageName: "leaf.circle",
            calories: 510,
            protein: 21,
            carbs: 52,
            fat: 24,
            description: "Crispy falafel with hummus, salad, and pita bread.",
            category: "Lunch"
        ),
        Meal(
            id: "teriyaki-chicken-rice",
            name: "Teriyaki Chicken Rice",
            imageName: "takeoutbag.and.cup.and.straw.fill",
            calories: 560,
            protein: 34,
            carbs: 62,
            fat: 16,
            description: "Sweet and savory teriyaki chicken served over steamed rice.",
            category: "Dinner"
        ),
        Meal(
            id: "oatmeal-with-fruits",
            name: "Oatmeal with Fruits",
            imageName: "sunrise",
            calories: 350,
            protein: 14,
            carbs: 55,
            fat: 8,
            description: "Oatmeal topped with banana, berries, and honey.",
            category: "Breakfast"
        )
        ,
        Meal(
            id: "fruit-yogurt-cup",
            name: "Fruit Yogurt Cup",
            imageName: "cup.and.saucer",
            calories: 260,
            protein: 17,
            carbs: 28,
            fat: 8,
            description: "Creamy yogurt with fresh fruit and a touch of honey—light and refreshing.",
            category: "Snack"
        ),
        Meal(
            id: "dark-chocolate-mousse",
            name: "Dark Chocolate Mousse",
            imageName: "birthday.cake",
            calories: 410,
            protein: 7,
            carbs: 36,
            fat: 26,
            description: "Rich, airy chocolate mousse finished with cocoa dusting.",
            category: "Dessert"
        )
    ]
}

