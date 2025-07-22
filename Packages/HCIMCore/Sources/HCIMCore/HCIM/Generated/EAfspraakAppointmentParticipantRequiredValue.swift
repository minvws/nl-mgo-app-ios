import Foundation

public enum EAfspraakAppointmentParticipantRequiredValue: String, Codable, Hashable, Sendable {
    case informationOnly = "information-only"
    case valueOptional = "optional"
    case valueRequired = "required"
}
