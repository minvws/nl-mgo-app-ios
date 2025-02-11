import Foundation

public enum ZibNutritionAdviceStatus: String, Codable, Hashable, Sendable {
    case active = "active"
    case cancelled = "cancelled"
    case completed = "completed"
    case draft = "draft"
    case enteredInError = "entered-in-error"
    case onHold = "on-hold"
    case planned = "planned"
    case proposed = "proposed"
    case requested = "requested"
}
