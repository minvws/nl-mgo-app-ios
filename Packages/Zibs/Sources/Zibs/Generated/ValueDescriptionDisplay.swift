import Foundation

public enum ValueDescriptionDisplay: Codable, Hashable, Sendable {
    case string(String)
    case unionArray([DisplayElement])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([DisplayElement].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ValueDescriptionDisplay.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueDescriptionDisplay"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        }
    }
}
