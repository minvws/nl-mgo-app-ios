import Foundation

public enum GpLaboratoryResultStatus: String, Codable, Hashable, Sendable {
    case amended = "amended"
    case cancelled = "cancelled"
    case corrected = "corrected"
    case enteredInError = "entered-in-error"
    case preliminary = "preliminary"
    case registered = "registered"
    case statusFinal = "final"
    case unknown = "unknown"
}
