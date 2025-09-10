import Foundation

public enum HilariousGiven: Codable, Hashable, Sendable {
    case primitiveValueTypeOfStringStringArray([PrimitiveValueTypeOfStringString])
    case stickyGiven(StickyGiven)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([PrimitiveValueTypeOfStringString].self) {
            self = .primitiveValueTypeOfStringStringArray(x)
            return
        }
        if let x = try? container.decode(StickyGiven.self) {
            self = .stickyGiven(x)
            return
        }
        throw DecodingError.typeMismatch(HilariousGiven.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for HilariousGiven"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .primitiveValueTypeOfStringStringArray(let x):
            try container.encode(x)
        case .stickyGiven(let x):
            try container.encode(x)
        }
    }
}
