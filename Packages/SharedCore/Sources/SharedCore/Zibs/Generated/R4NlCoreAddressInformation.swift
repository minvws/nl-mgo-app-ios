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
    public let additionalInformation: String?
    public let addressType: MgoCodeableConcept?
    public let city, country: String?
    public let countryCode: MgoCodeableConcept?
    public let district, houseNumber, houseNumberAddition, houseNumberIndication: String?
    public let line: String?
    public let period: MgoPeriod?
    public let postalCode, streetName: String?

    public init(additionalInformation: String?, addressType: MgoCodeableConcept?, city: String?, country: String?, countryCode: MgoCodeableConcept?, district: String?, houseNumber: String?, houseNumberAddition: String?, houseNumberIndication: String?, line: String?, period: MgoPeriod?, postalCode: String?, streetName: String?) {
        self.additionalInformation = additionalInformation
        self.addressType = addressType
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.district = district
        self.houseNumber = houseNumber
        self.houseNumberAddition = houseNumberAddition
        self.houseNumberIndication = houseNumberIndication
        self.line = line
        self.period = period
        self.postalCode = postalCode
        self.streetName = streetName
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
        additionalInformation: String?? = nil,
        addressType: MgoCodeableConcept?? = nil,
        city: String?? = nil,
        country: String?? = nil,
        countryCode: MgoCodeableConcept?? = nil,
        district: String?? = nil,
        houseNumber: String?? = nil,
        houseNumberAddition: String?? = nil,
        houseNumberIndication: String?? = nil,
        line: String?? = nil,
        period: MgoPeriod?? = nil,
        postalCode: String?? = nil,
        streetName: String?? = nil
    ) -> R4NlCoreAddressInformation {
        return R4NlCoreAddressInformation(
            additionalInformation: additionalInformation ?? self.additionalInformation,
            addressType: addressType ?? self.addressType,
            city: city ?? self.city,
            country: country ?? self.country,
            countryCode: countryCode ?? self.countryCode,
            district: district ?? self.district,
            houseNumber: houseNumber ?? self.houseNumber,
            houseNumberAddition: houseNumberAddition ?? self.houseNumberAddition,
            houseNumberIndication: houseNumberIndication ?? self.houseNumberIndication,
            line: line ?? self.line,
            period: period ?? self.period,
            postalCode: postalCode ?? self.postalCode,
            streetName: streetName ?? self.streetName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
