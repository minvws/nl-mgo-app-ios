// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreNameInformationGiven = try R4NlCoreNameInformationGiven(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreNameInformationGiven
public struct R4NlCoreNameInformationGiven: Codable, Hashable, Sendable {
    public let given: [String]?
    public let period: MgoPeriod?
    public let text: String?
    public let use: R4NlCoreNameInformationGivenUse

    public init(given: [String]?, period: MgoPeriod?, text: String?, use: R4NlCoreNameInformationGivenUse) {
        self.given = given
        self.period = period
        self.text = text
        self.use = use
    }
}

// MARK: R4NlCoreNameInformationGiven convenience initializers and mutators

public extension R4NlCoreNameInformationGiven {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreNameInformationGiven.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        given: [String]?? = nil,
        period: MgoPeriod?? = nil,
        text: String?? = nil,
        use: R4NlCoreNameInformationGivenUse? = nil
    ) -> R4NlCoreNameInformationGiven {
        return R4NlCoreNameInformationGiven(
            given: given ?? self.given,
            period: period ?? self.period,
            text: text ?? self.text,
            use: use ?? self.use
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
