import Foundation

public enum IheMhdMinimalDocumentReferenceStatusValue: String, Codable, Hashable, Sendable {
    case current = "current"
    case enteredInError = "entered-in-error"
    case superseded = "superseded"
}
