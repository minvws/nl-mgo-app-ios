import Foundation

public enum MgoCodeOfRequiredOptionalInformationOnlyValue: String, Codable, Hashable, Sendable {
    case informationOnly = "information-only"
    case valueOptional = "optional"
    case valueRequired = "required"
}
