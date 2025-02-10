import Foundation

public enum ZibMedicationAgreementStatus: String, Codable, Hashable, Sendable {
    case active = "active"
    case cancelled = "cancelled"
    case completed = "completed"
    case draft = "draft"
    case enteredInError = "entered-in-error"
    case onHold = "on-hold"
    case stopped = "stopped"
    case unknown = "unknown"
}
