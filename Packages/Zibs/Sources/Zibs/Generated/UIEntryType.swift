import Foundation

public enum UIEntryType: String, Codable, Hashable, Sendable {
    case downloadLink = "DOWNLOAD_LINK"
    case multipleGroupedValues = "MULTIPLE_GROUPED_VALUES"
    case multipleValues = "MULTIPLE_VALUES"
    case referenceValue = "REFERENCE_VALUE"
    case singleValue = "SINGLE_VALUE"
}
