import Foundation

public enum ZibTreatmentDirectiveStatus: String, Codable, Hashable, Sendable {
    case active = "active"
    case draft = "draft"
    case enteredInError = "entered-in-error"
    case inactive = "inactive"
    case proposed = "proposed"
    case rejected = "rejected"
}
