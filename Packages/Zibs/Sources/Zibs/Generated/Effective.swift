import Foundation

public enum Effective: Codable, Hashable, Sendable {
    case mgoPeriod(MgoPeriod)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(MgoPeriod.self) {
            self = .mgoPeriod(x)
            return
        }
        throw DecodingError.typeMismatch(Effective.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Effective"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .mgoPeriod(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
