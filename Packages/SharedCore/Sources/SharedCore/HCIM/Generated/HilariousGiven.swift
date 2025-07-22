import Foundation

public enum HilariousGiven: Codable, Hashable, Sendable {
    case mgoStringArray([MgoString])
    case stickyGiven(StickyGiven)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([MgoString].self) {
            self = .mgoStringArray(x)
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
        case .mgoStringArray(let x):
            try container.encode(x)
        case .stickyGiven(let x):
            try container.encode(x)
        }
    }
}
