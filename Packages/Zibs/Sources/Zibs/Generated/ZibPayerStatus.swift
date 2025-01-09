import Foundation

public enum ZibPayerStatus: String, Codable, Hashable, Sendable {
    case active = "active"
    case cancelled = "cancelled"
    case draft = "draft"
    case enteredInError = "entered-in-error"
}
