// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthProfessionalPractitionerName = try R4NlCoreHealthProfessionalPractitionerName(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthProfessionalPractitionerName
public struct R4NlCoreHealthProfessionalPractitionerName: Codable, Hashable, Sendable {
    public let profile: PurpleProfile
    public let family: TentacledFamily?
    public let given: IndigoGiven?
    public let period: MgoPeriod?
    public let namePrefix, suffix: [MgoString]?
    public let text: MgoString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case family, given, period
        case namePrefix = "prefix"
        case suffix, text
    }

    public init(profile: PurpleProfile, family: TentacledFamily?, given: IndigoGiven?, period: MgoPeriod?, namePrefix: [MgoString]?, suffix: [MgoString]?, text: MgoString?) {
        self.profile = profile
        self.family = family
        self.given = given
        self.period = period
        self.namePrefix = namePrefix
        self.suffix = suffix
        self.text = text
    }
}

// MARK: R4NlCoreHealthProfessionalPractitionerName convenience initializers and mutators

public extension R4NlCoreHealthProfessionalPractitionerName {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthProfessionalPractitionerName.self, from: data)
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
        profile: PurpleProfile? = nil,
        family: TentacledFamily?? = nil,
        given: IndigoGiven?? = nil,
        period: MgoPeriod?? = nil,
        namePrefix: [MgoString]?? = nil,
        suffix: [MgoString]?? = nil,
        text: MgoString?? = nil
    ) -> R4NlCoreHealthProfessionalPractitionerName {
        return R4NlCoreHealthProfessionalPractitionerName(
            profile: profile ?? self.profile,
            family: family ?? self.family,
            given: given ?? self.given,
            period: period ?? self.period,
            namePrefix: namePrefix ?? self.namePrefix,
            suffix: suffix ?? self.suffix,
            text: text ?? self.text
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
