import Foundation

public enum Priority: String, Codable, Hashable, Sendable {
    case asap = "asap"
    case routine = "routine"
    case stat = "stat"
    case urgent = "urgent"
}
