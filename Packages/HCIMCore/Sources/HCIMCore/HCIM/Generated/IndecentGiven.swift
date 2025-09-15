import Foundation

public enum IndecentGiven: Codable, Hashable, Sendable {
    case primitiveValueTypeOfStringStringArray([PrimitiveValueTypeOfStringString])
    case r4NlCoreNameInformationGivenClass(R4NlCoreNameInformationGivenClass)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([PrimitiveValueTypeOfStringString].self) {
            self = .primitiveValueTypeOfStringStringArray(x)
            return
        }
        if let x = try? container.decode(R4NlCoreNameInformationGivenClass.self) {
            self = .r4NlCoreNameInformationGivenClass(x)
            return
        }
        throw DecodingError.typeMismatch(IndecentGiven.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for IndecentGiven"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .primitiveValueTypeOfStringStringArray(let x):
            try container.encode(x)
        case .r4NlCoreNameInformationGivenClass(let x):
            try container.encode(x)
        }
    }
}
