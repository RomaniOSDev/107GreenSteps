import Foundation

struct EcoGoal: Identifiable, Codable {
    let id: UUID
    var name: String
    var targetValue: Double
    var currentValue: Double
    var unit: ImpactUnit
    var deadline: Date?
    var isCompleted: Bool
    let createdAt: Date

    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(currentValue / targetValue, 1.0)
    }
}
