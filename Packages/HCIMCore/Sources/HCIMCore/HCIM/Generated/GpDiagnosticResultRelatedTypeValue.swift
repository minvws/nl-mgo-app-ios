import Foundation

public enum GpDiagnosticResultRelatedTypeValue: String, Codable, Hashable, Sendable {
    case derivedFrom = "derived-from"
    case hasMember = "has-member"
    case interferedBy = "interfered-by"
    case qualifiedBy = "qualified-by"
    case replaces = "replaces"
    case sequelTo = "sequel-to"
}
