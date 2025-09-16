import Foundation

public enum SingleValueDisplay: Codable, Hashable, Sendable {
    case displayCoding(DisplayCoding)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(DisplayCoding.self) {
            self = .displayCoding(x)
            return
        }
        throw DecodingError.typeMismatch(SingleValueDisplay.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SingleValueDisplay"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .displayCoding(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
