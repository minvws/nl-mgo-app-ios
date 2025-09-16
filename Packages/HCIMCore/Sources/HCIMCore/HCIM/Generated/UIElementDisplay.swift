import Foundation

public enum UIElementDisplay: Codable, Hashable, Sendable {
    case displayCoding(DisplayCoding)
    case string(String)
    case unionArray([PurpleDisplay])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([PurpleDisplay].self) {
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
        throw DecodingError.typeMismatch(UIElementDisplay.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for UIElementDisplay"))
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
