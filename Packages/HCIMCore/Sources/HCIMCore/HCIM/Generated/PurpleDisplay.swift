import Foundation

public enum PurpleDisplay: Codable, Hashable, Sendable {
    case displayCoding(DisplayCoding)
    case string(String)
    case unionArray([SingleValueDisplay])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([SingleValueDisplay].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(DisplayCoding.self) {
            self = .displayCoding(x)
            return
        }
        throw DecodingError.typeMismatch(PurpleDisplay.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PurpleDisplay"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .displayCoding(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        }
    }
}
