import Foundation

struct EcoChallenge: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var duration: Int
    var startDate: Date
    var habits: [UUID]
    var participants: [String]?
    var isActive: Bool
}
