import Foundation

struct EcoAction: Identifiable, Codable {
    let id: UUID
    let habitId: UUID
    var habitName: String
    var impactPerAction: Double
    var impactUnit: ImpactUnit
    let date: Date
    var quantity: Int
    var notes: String?
    var location: String?

    var impactSaved: Double {
        Double(quantity) * impactPerAction
    }
}
