import Foundation

public enum PurpleValue: String, Codable, Hashable, Sendable {
    case arrived = "arrived"
    case booked = "booked"
    case cancelled = "cancelled"
    case enteredInError = "entered-in-error"
    case fulfilled = "fulfilled"
    case noshow = "noshow"
    case pending = "pending"
    case proposed = "proposed"
}
