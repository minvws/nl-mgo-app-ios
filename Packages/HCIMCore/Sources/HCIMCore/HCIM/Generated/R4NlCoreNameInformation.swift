// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreNameInformation = try R4NlCoreNameInformation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreNameInformation
public struct R4NlCoreNameInformation: Codable, Hashable, Sendable {
    public let profile: R4NlCoreNameInformationProfile
    public let family: R4NlCoreNameInformationFamily
    public let given: R4NlCoreNameInformationGivenClass
    public let period: MgoPeriod?
    public let r4NlCoreNameInformationPrefix, suffix: [PrimitiveValueTypeOfStringString]?
    public let text: PrimitiveValueTypeOfStringString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case family, given, period
        case r4NlCoreNameInformationPrefix = "prefix"
        case suffix, text
    }

    public init(profile: R4NlCoreNameInformationProfile, family: R4NlCoreNameInformationFamily, given: R4NlCoreNameInformationGivenClass, period: MgoPeriod?, r4NlCoreNameInformationPrefix: [PrimitiveValueTypeOfStringString]?, suffix: [PrimitiveValueTypeOfStringString]?, text: PrimitiveValueTypeOfStringString?) {
        self.profile = profile
        self.family = family
        self.given = given
        self.period = period
        self.r4NlCoreNameInformationPrefix = r4NlCoreNameInformationPrefix
        self.suffix = suffix
        self.text = text
    }
}

// MARK: R4NlCoreNameInformation convenience initializers and mutators

public extension R4NlCoreNameInformation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreNameInformation.self, from: data)
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
        profile: R4NlCoreNameInformationProfile? = nil,
        family: R4NlCoreNameInformationFamily? = nil,
        given: R4NlCoreNameInformationGivenClass? = nil,
        period: MgoPeriod?? = nil,
        r4NlCoreNameInformationPrefix: [PrimitiveValueTypeOfStringString]?? = nil,
        suffix: [PrimitiveValueTypeOfStringString]?? = nil,
        text: PrimitiveValueTypeOfStringString?? = nil
    ) -> R4NlCoreNameInformation {
        return R4NlCoreNameInformation(
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
