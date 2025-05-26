import Foundation

public enum ZibAllergyIntoleranceVerificationstatusValue: String, Codable, Hashable, Sendable {
    case confirmed = "confirmed"
    case enteredInError = "entered-in-error"
    case refuted = "refuted"
    case unconfirmed = "unconfirmed"
}
