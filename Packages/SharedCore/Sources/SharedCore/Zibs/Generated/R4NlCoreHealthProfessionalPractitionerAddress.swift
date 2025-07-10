// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthProfessionalPractitionerAddress = try R4NlCoreHealthProfessionalPractitionerAddress(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthProfessionalPractitionerAddress
public struct R4NlCoreHealthProfessionalPractitionerAddress: Codable, Hashable, Sendable {
    public let profile: R4NlCoreAddressInformationProfile
    public let city: MgoString?
    public let country: FluffyCountry
    public let district: MgoString?
    public let line: [IndigoLine]?
    public let postalCode: MgoString?
    public let type, use: NlCoreOrganizationTelecomSystem?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case city, country, district, line, postalCode, type, use
    }

    public init(profile: R4NlCoreAddressInformationProfile, city: MgoString?, country: FluffyCountry, district: MgoString?, line: [IndigoLine]?, postalCode: MgoString?, type: NlCoreOrganizationTelecomSystem?, use: NlCoreOrganizationTelecomSystem?) {
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

// MARK: R4NlCoreHealthProfessionalPractitionerAddress convenience initializers and mutators

public extension R4NlCoreHealthProfessionalPractitionerAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthProfessionalPractitionerAddress.self, from: data)
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
        city: MgoString?? = nil,
        country: FluffyCountry? = nil,
        district: MgoString?? = nil,
        line: [IndigoLine]?? = nil,
        postalCode: MgoString?? = nil,
        type: NlCoreOrganizationTelecomSystem?? = nil,
        use: NlCoreOrganizationTelecomSystem?? = nil
    ) -> R4NlCoreHealthProfessionalPractitionerAddress {
        return R4NlCoreHealthProfessionalPractitionerAddress(
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
