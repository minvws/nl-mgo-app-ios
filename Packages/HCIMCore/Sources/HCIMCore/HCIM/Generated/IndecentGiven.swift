import Foundation

public enum IndecentGiven: Codable, Hashable, Sendable {
    case mgoStringArray([MgoString])
    case r4NlCoreNameInformationGivenClass(R4NlCoreNameInformationGivenClass)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([MgoString].self) {
            self = .mgoStringArray(x)
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
        case .mgoStringArray(let x):
            try container.encode(x)
        case .r4NlCoreNameInformationGivenClass(let x):
            try container.encode(x)
        }
    }
}
