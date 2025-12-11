import Foundation

public enum UIElementValue: Codable, Hashable, Sendable {
    case displayValue(DisplayValue)
    case unionArray([ValueElement])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([ValueElement].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(DisplayValue.self) {
            self = .displayValue(x)
            return
        }
        throw DecodingError.typeMismatch(UIElementValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for UIElementValue"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .displayValue(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        }
    }
}
