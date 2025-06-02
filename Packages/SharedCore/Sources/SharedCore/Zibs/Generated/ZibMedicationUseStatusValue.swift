import Foundation

public enum ZibMedicationUseStatusValue: String, Codable, Hashable, Sendable {
    case active = "active"
    case completed = "completed"
    case enteredInError = "entered-in-error"
    case intended = "intended"
    case onHold = "on-hold"
    case stopped = "stopped"
}
