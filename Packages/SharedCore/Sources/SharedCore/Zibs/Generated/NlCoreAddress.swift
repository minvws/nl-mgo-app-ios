// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreAddress = try NlCoreAddress(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreAddress
public struct NlCoreAddress: Codable, Hashable, Sendable {
    public let profile: NlCoreAddressProfile
    public let addressType: MgoCodeableConcept?
    public let city, country, district: MgoString?
    public let line: [NlCoreAddressLine]?
    public let official: MgoBoolean?
    public let postalCode: MgoString?
    public let type, use: MgoCode?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case addressType, city, country, district, line, official, postalCode, type, use
    }

    public init(profile: NlCoreAddressProfile, addressType: MgoCodeableConcept?, city: MgoString?, country: MgoString?, district: MgoString?, line: [NlCoreAddressLine]?, official: MgoBoolean?, postalCode: MgoString?, type: MgoCode?, use: MgoCode?) {
        self.profile = profile
        self.addressType = addressType
        self.city = city
        self.country = country
        self.district = district
        self.line = line
        self.official = official
        self.postalCode = postalCode
        self.type = type
        self.use = use
    }
}

// MARK: NlCoreAddress convenience initializers and mutators

public extension NlCoreAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreAddress.self, from: data)
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
        profile: NlCoreAddressProfile? = nil,
        addressType: MgoCodeableConcept?? = nil,
        city: MgoString?? = nil,
        country: MgoString?? = nil,
        district: MgoString?? = nil,
        line: [NlCoreAddressLine]?? = nil,
        official: MgoBoolean?? = nil,
        postalCode: MgoString?? = nil,
        type: MgoCode?? = nil,
        use: MgoCode?? = nil
    ) -> NlCoreAddress {
        return NlCoreAddress(
            profile: profile ?? self.profile,
            addressType: addressType ?? self.addressType,
            city: city ?? self.city,
            country: country ?? self.country,
            district: district ?? self.district,
            line: line ?? self.line,
            official: official ?? self.official,
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
