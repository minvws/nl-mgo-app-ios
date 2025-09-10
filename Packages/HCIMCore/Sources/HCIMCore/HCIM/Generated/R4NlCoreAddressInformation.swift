// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreAddressInformation = try R4NlCoreAddressInformation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreAddressInformation
public struct R4NlCoreAddressInformation: Codable, Hashable, Sendable {
    public let profile: R4NlCoreAddressInformationProfile
    public let city: PrimitiveValueTypeOfStringString?
    public let country: R4NlCoreAddressInformationCountry
    public let district: PrimitiveValueTypeOfStringString?
    public let line: [R4NlCoreAddressInformationLine]?
    public let postalCode: PrimitiveValueTypeOfStringString?
    public let type, use: MgoCode?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case city, country, district, line, postalCode, type, use
    }

    public init(profile: R4NlCoreAddressInformationProfile, city: PrimitiveValueTypeOfStringString?, country: R4NlCoreAddressInformationCountry, district: PrimitiveValueTypeOfStringString?, line: [R4NlCoreAddressInformationLine]?, postalCode: PrimitiveValueTypeOfStringString?, type: MgoCode?, use: MgoCode?) {
        self.profile = profile
        self.city = city
        self.country = country
        self.district = district
        self.line = line
        self.postalCode = postalCode
        self.type = type
        self.use = use
    }
}

// MARK: R4NlCoreAddressInformation convenience initializers and mutators

public extension R4NlCoreAddressInformation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreAddressInformation.self, from: data)
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
        profile: R4NlCoreAddressInformationProfile? = nil,
        city: PrimitiveValueTypeOfStringString?? = nil,
        country: R4NlCoreAddressInformationCountry? = nil,
        district: PrimitiveValueTypeOfStringString?? = nil,
        line: [R4NlCoreAddressInformationLine]?? = nil,
        postalCode: PrimitiveValueTypeOfStringString?? = nil,
        type: MgoCode?? = nil,
        use: MgoCode?? = nil
    ) -> R4NlCoreAddressInformation {
        return R4NlCoreAddressInformation(
            profile: profile ?? self.profile,
            city: city ?? self.city,
            country: country ?? self.country,
            district: district ?? self.district,
            line: line ?? self.line,
            postalCode: postalCode ?? self.postalCode,
            type: type ?? self.type,
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
