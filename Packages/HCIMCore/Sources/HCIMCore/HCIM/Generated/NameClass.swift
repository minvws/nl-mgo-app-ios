// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nameClass = try NameClass(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NameClass
public struct NameClass: Codable, Hashable, Sendable {
    public let profile: PurpleProfile
    public let family: R4NlCoreNameInformationFamily?
    public let given: HilariousGiven?
    public let period: MgoPeriod?
    public let r4NlCoreNameInformationPrefix, suffix: [PrimitiveValueTypeOfStringString]?
    public let text: PrimitiveValueTypeOfStringString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case family, given, period
        case r4NlCoreNameInformationPrefix = "prefix"
        case suffix, text
    }

    public init(profile: PurpleProfile, family: R4NlCoreNameInformationFamily?, given: HilariousGiven?, period: MgoPeriod?, r4NlCoreNameInformationPrefix: [PrimitiveValueTypeOfStringString]?, suffix: [PrimitiveValueTypeOfStringString]?, text: PrimitiveValueTypeOfStringString?) {
        self.profile = profile
        self.family = family
        self.given = given
        self.period = period
        self.r4NlCoreNameInformationPrefix = r4NlCoreNameInformationPrefix
        self.suffix = suffix
        self.text = text
    }
}

// MARK: NameClass convenience initializers and mutators

public extension NameClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NameClass.self, from: data)
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
        family: R4NlCoreNameInformationFamily?? = nil,
        given: HilariousGiven?? = nil,
        period: MgoPeriod?? = nil,
        r4NlCoreNameInformationPrefix: [PrimitiveValueTypeOfStringString]?? = nil,
        suffix: [PrimitiveValueTypeOfStringString]?? = nil,
        text: PrimitiveValueTypeOfStringString?? = nil
    ) -> NameClass {
        return NameClass(
            profile: profile ?? self.profile,
            family: family ?? self.family,
            given: given ?? self.given,
            period: period ?? self.period,
            r4NlCoreNameInformationPrefix: r4NlCoreNameInformationPrefix ?? self.r4NlCoreNameInformationPrefix,
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
