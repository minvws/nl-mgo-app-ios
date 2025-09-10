import Foundation

public enum MgoCodeOfAcceptedDeclinedTentativeNeedsActionValue: String, Codable, Hashable, Sendable {
    case accepted = "accepted"
    case declined = "declined"
    case needsAction = "needs-action"
    case tentative = "tentative"
}
