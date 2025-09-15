// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibVaccinationRecommendation = try ZibVaccinationRecommendation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibVaccinationRecommendation
public struct ZibVaccinationRecommendation: Codable, Hashable, Sendable {
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let orderStatus: ExtensionValueOfMgoCodeableConcept?
    public let profile: ZibVaccinationRecommendationProfile
    public let recommendation: [Recommendation]?
    public let referenceID, resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case fhirVersion, id, identifier, orderStatus, profile, recommendation
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, orderStatus: ExtensionValueOfMgoCodeableConcept?, profile: ZibVaccinationRecommendationProfile, recommendation: [Recommendation]?, referenceID: String, resourceType: String, subject: MgoReference?) {
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.orderStatus = orderStatus
        self.profile = profile
        self.recommendation = recommendation
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: ZibVaccinationRecommendation convenience initializers and mutators

public extension ZibVaccinationRecommendation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibVaccinationRecommendation.self, from: data)
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
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        orderStatus: ExtensionValueOfMgoCodeableConcept?? = nil,
        profile: ZibVaccinationRecommendationProfile? = nil,
        recommendation: [Recommendation]?? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> ZibVaccinationRecommendation {
        return ZibVaccinationRecommendation(
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            orderStatus: orderStatus ?? self.orderStatus,
            profile: profile ?? self.profile,
            recommendation: recommendation ?? self.recommendation,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
