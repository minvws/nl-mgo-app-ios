import Foundation

public enum Criticality: String, Codable, Hashable, Sendable {
    case high = "high"
    case low = "low"
    case unableToAssess = "unable-to-assess"
}
