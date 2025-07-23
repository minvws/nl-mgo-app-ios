import Foundation

public enum EAfspraakAppointmentParticipantStatusValue: String, Codable, Hashable, Sendable {
    case accepted = "accepted"
    case declined = "declined"
    case needsAction = "needs-action"
    case tentative = "tentative"
}
