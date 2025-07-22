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
    public let profile: PurpleProfile
    public let family: StickyFamily?
    public let given: HilariousGiven?
    public let period: MgoPeriod?
    public let namePrefix, suffix: [MgoString]?
    public let text: MgoString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case family, given, period
        case namePrefix = "prefix"
        case suffix, text
    }

    public init(profile: PurpleProfile, family: StickyFamily?, given: HilariousGiven?, period: MgoPeriod?, namePrefix: [MgoString]?, suffix: [MgoString]?, text: MgoString?) {
        self.profile = profile
        self.family = family
        self.given = given
        self.period = period
        self.namePrefix = namePrefix
        self.suffix = suffix
        self.text = text
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
        profile: PurpleProfile? = nil,
        family: StickyFamily?? = nil,
        given: HilariousGiven?? = nil,
        period: MgoPeriod?? = nil,
        namePrefix: [MgoString]?? = nil,
        suffix: [MgoString]?? = nil,
        text: MgoString?? = nil
    ) -> R4NlCorePatientName {
        return R4NlCorePatientName(
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
