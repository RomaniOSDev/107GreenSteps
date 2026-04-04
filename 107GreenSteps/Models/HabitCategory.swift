import Foundation

enum HabitCategory: String, CaseIterable, Codable {
    case waste = "Waste"
    case energy = "Energy"
    case water = "Water"
    case transport = "Transport"
    case food = "Food"
    case shopping = "Shopping"
    case other = "Other"

    var icon: String {
        switch self {
        case .waste: return "trash.fill"
        case .energy: return "bolt.fill"
        case .water: return "drop.fill"
        case .transport: return "bus.fill"
        case .food: return "leaf.fill"
        case .shopping: return "bag.fill"
        case .other: return "heart.fill"
        }
    }

    var emoji: String {
        switch self {
        case .waste: return "🗑️"
        case .energy: return "⚡"
        case .water: return "💧"
        case .transport: return "🚲"
        case .food: return "🥬"
        case .shopping: return "🛍️"
        case .other: return "🌱"
        }
    }
}

enum ImpactUnit: String, CaseIterable, Codable {
    case kg = "kg CO2"
    case liters = "liters"
    case pieces = "pieces"
    case bags = "bags"
    case bottles = "bottles"
    case km = "km"
    case kWh = "kWh"
}
