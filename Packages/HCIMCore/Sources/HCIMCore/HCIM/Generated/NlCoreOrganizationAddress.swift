// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreOrganizationAddress = try NlCoreOrganizationAddress(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreOrganizationAddress
public struct NlCoreOrganizationAddress: Codable, Hashable, Sendable {
    public let profile: NlCoreAddressProfile
    public let addressType: MgoCodeableConcept?
    public let city, country, district: PrimitiveValueTypeOfStringString?
    public let line: [NlCoreAddressStreetNameHouseNumber]?
    public let official: PrimitiveValueTypeOfBooleanBoolean?
    public let postalCode: PrimitiveValueTypeOfStringString?
    public let type, use: MgoCodeOfString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case addressType, city, country, district, line, official, postalCode, type, use
    }

    public init(profile: NlCoreAddressProfile, addressType: MgoCodeableConcept?, city: PrimitiveValueTypeOfStringString?, country: PrimitiveValueTypeOfStringString?, district: PrimitiveValueTypeOfStringString?, line: [NlCoreAddressStreetNameHouseNumber]?, official: PrimitiveValueTypeOfBooleanBoolean?, postalCode: PrimitiveValueTypeOfStringString?, type: MgoCodeOfString?, use: MgoCodeOfString?) {
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

// MARK: NlCoreOrganizationAddress convenience initializers and mutators

public extension NlCoreOrganizationAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreOrganizationAddress.self, from: data)
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
        city: PrimitiveValueTypeOfStringString?? = nil,
        country: PrimitiveValueTypeOfStringString?? = nil,
        district: PrimitiveValueTypeOfStringString?? = nil,
        line: [NlCoreAddressStreetNameHouseNumber]?? = nil,
        official: PrimitiveValueTypeOfBooleanBoolean?? = nil,
        postalCode: PrimitiveValueTypeOfStringString?? = nil,
        type: MgoCodeOfString?? = nil,
        use: MgoCodeOfString?? = nil
    ) -> NlCoreOrganizationAddress {
        return NlCoreOrganizationAddress(
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
