// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibPayer = try ZibPayer(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibPayer
public struct ZibPayer: Codable, Hashable, Sendable {
    public let beneficiary: MgoReference?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let payor: [Payor]?
    public let period: MgoPeriod?
    public let profile: ZibPayerProfile
    public let referenceID, resourceType: String
    public let subscriberID: MgoString?
    public let type: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case beneficiary, fhirVersion, id, identifier, payor, period, profile
        case referenceID = "referenceId"
        case resourceType
        case subscriberID = "subscriberId"
        case type
    }

    public init(beneficiary: MgoReference?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, payor: [Payor]?, period: MgoPeriod?, profile: ZibPayerProfile, referenceID: String, resourceType: String, subscriberID: MgoString?, type: MgoCodeableConcept?) {
        self.beneficiary = beneficiary
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.payor = payor
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subscriberID = subscriberID
        self.type = type
    }
}

// MARK: ZibPayer convenience initializers and mutators

public extension ZibPayer {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibPayer.self, from: data)
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
        beneficiary: MgoReference?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        payor: [Payor]?? = nil,
        period: MgoPeriod?? = nil,
        profile: ZibPayerProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subscriberID: MgoString?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> ZibPayer {
        return ZibPayer(
            beneficiary: beneficiary ?? self.beneficiary,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            payor: payor ?? self.payor,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subscriberID: subscriberID ?? self.subscriberID,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
