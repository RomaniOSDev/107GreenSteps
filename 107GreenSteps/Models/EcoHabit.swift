import Foundation

struct EcoHabit: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var description: String
    var impactPerAction: Double
    var impactUnit: ImpactUnit
    var isActive: Bool
    var dailyGoal: Int
    var reminderTime: Date?
    var isFavorite: Bool
    let createdAt: Date
}
