import Foundation

public enum ValueElement: Codable, Hashable, Sendable {
    case displayValue(DisplayValue)
    case displayValueArray([DisplayValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([DisplayValue].self) {
            self = .displayValueArray(x)
            return
        }
        if let x = try? container.decode(DisplayValue.self) {
            self = .displayValue(x)
            return
        }
        throw DecodingError.typeMismatch(ValueElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueElement"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .displayValue(let x):
            try container.encode(x)
        case .displayValueArray(let x):
            try container.encode(x)
        }
    }
}
