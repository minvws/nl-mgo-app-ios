import Foundation

public enum ZibProblemClinicalStatus: String, Codable, Hashable, Sendable {
    case active = "active"
    case inactive = "inactive"
    case recurrence = "recurrence"
    case remission = "remission"
    case resolved = "resolved"
}
