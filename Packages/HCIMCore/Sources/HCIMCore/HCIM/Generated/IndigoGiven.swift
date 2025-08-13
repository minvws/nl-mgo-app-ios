import Foundation

public enum IndigoGiven: Codable, Hashable, Sendable {
    case mgoStringArray([MgoString])
    case tentacledGiven(TentacledGiven)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([MgoString].self) {
            self = .mgoStringArray(x)
            return
        }
        if let x = try? container.decode(TentacledGiven.self) {
            self = .tentacledGiven(x)
            return
        }
        throw DecodingError.typeMismatch(IndigoGiven.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for IndigoGiven"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .mgoStringArray(let x):
            try container.encode(x)
        case .tentacledGiven(let x):
            try container.encode(x)
        }
    }
}
