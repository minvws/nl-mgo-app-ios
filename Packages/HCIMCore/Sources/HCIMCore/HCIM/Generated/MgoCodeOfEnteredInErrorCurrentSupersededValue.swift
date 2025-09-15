import Foundation

public enum MgoCodeOfEnteredInErrorCurrentSupersededValue: String, Codable, Hashable, Sendable {
    case current = "current"
    case enteredInError = "entered-in-error"
    case superseded = "superseded"
}
