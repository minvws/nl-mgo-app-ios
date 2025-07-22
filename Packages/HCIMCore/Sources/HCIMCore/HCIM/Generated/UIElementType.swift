import Foundation

public enum UIElementType: String, Codable, Hashable, Sendable {
    case downloadBinary = "DOWNLOAD_BINARY"
    case downloadLink = "DOWNLOAD_LINK"
    case multipleGroupedValues = "MULTIPLE_GROUPED_VALUES"
    case multipleValues = "MULTIPLE_VALUES"
    case referenceLink = "REFERENCE_LINK"
    case referenceValue = "REFERENCE_VALUE"
    case singleValue = "SINGLE_VALUE"
}
