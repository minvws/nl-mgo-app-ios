import Foundation

public enum AmbitiousGiven: Codable, Hashable, Sendable {
    case indigoGiven(IndigoGiven)
    case mgoStringArray([MgoString])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([MgoString].self) {
            self = .mgoStringArray(x)
            return
        }
        if let x = try? container.decode(IndigoGiven.self) {
            self = .indigoGiven(x)
            return
        }
        throw DecodingError.typeMismatch(AmbitiousGiven.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AmbitiousGiven"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .indigoGiven(let x):
            try container.encode(x)
        case .mgoStringArray(let x):
            try container.encode(x)
        }
    }
}
