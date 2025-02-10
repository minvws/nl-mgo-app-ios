import Foundation

public enum ZibProblemVerificationStatus: String, Codable, Hashable, Sendable {
    case confirmed = "confirmed"
    case differential = "differential"
    case enteredInError = "entered-in-error"
    case provisional = "provisional"
    case refuted = "refuted"
    case unknown = "unknown"
}
