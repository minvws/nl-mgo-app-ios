import Foundation

public enum NlCoreEpisodeofcareStatus: String, Codable, Hashable, Sendable {
    case active = "active"
    case cancelled = "cancelled"
    case enteredInError = "entered-in-error"
    case finished = "finished"
    case onhold = "onhold"
    case planned = "planned"
    case waitlist = "waitlist"
}
