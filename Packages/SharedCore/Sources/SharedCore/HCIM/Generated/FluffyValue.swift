import Foundation

public enum FluffyValue: String, Codable, Hashable, Sendable {
    case amended = "amended"
    case cancelled = "cancelled"
    case corrected = "corrected"
    case enteredInError = "entered-in-error"
    case preliminary = "preliminary"
    case registered = "registered"
    case unknown = "unknown"
    case valueFinal = "final"
}
