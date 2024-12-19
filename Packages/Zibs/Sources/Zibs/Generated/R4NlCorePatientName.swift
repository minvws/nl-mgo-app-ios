// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePatientName = try R4NlCorePatientName(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePatientName
public struct R4NlCorePatientName: Codable, Hashable, Sendable {
    public let family: String?
    public let given, givenInitials, givenNames: [String]?
    public let nameUsage: String?
    public let period: MgoPeriod?
    public let namePrefix, suffix: [String]?
    public let text: String?
    public let use: Use

    public enum CodingKeys: String, CodingKey {
        case family, given, givenInitials, givenNames, nameUsage, period
        case namePrefix = "prefix"
        case suffix, text, use
    }

    public init(family: String?, given: [String]?, givenInitials: [String]?, givenNames: [String]?, nameUsage: String?, period: MgoPeriod?, namePrefix: [String]?, suffix: [String]?, text: String?, use: Use) {
        self.family = family
        self.given = given
        self.givenInitials = givenInitials
        self.givenNames = givenNames
        self.nameUsage = nameUsage
        self.period = period
        self.namePrefix = namePrefix
        self.suffix = suffix
        self.text = text
        self.use = use
    }
}

// MARK: R4NlCorePatientName convenience initializers and mutators

public extension R4NlCorePatientName {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePatientName.self, from: data)
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
        family: String?? = nil,
        given: [String]?? = nil,
        givenInitials: [String]?? = nil,
        givenNames: [String]?? = nil,
        nameUsage: String?? = nil,
        period: MgoPeriod?? = nil,
        namePrefix: [String]?? = nil,
        suffix: [String]?? = nil,
        text: String?? = nil,
        use: Use? = nil
    ) -> R4NlCorePatientName {
        return R4NlCorePatientName(
            family: family ?? self.family,
            given: given ?? self.given,
            givenInitials: givenInitials ?? self.givenInitials,
            givenNames: givenNames ?? self.givenNames,
            nameUsage: nameUsage ?? self.nameUsage,
            period: period ?? self.period,
            namePrefix: namePrefix ?? self.namePrefix,
            suffix: suffix ?? self.suffix,
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
