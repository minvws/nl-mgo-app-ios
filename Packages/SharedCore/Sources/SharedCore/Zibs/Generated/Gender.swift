import Foundation

public enum Gender: String, Codable, Hashable, Sendable {
    case female = "female"
    case male = "male"
    case other = "other"
    case unknown = "unknown"
}
