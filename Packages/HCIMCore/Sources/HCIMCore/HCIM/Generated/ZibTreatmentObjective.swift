// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTreatmentObjective = try ZibTreatmentObjective(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTreatmentObjective
public struct ZibTreatmentObjective: Codable, Hashable, Sendable {
    public let addresses: [MgoReference]?
    public let description: MgoCodeableConcept?
    public let expressedBy: MgoReference?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let profile: ZibTreatmentObjectiveProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?
    public let target: Target

    public enum CodingKeys: String, CodingKey {
        case addresses, description, expressedBy, fhirVersion, id, identifier, profile
        case referenceID = "referenceId"
        case resourceType, subject, target
    }

    public init(addresses: [MgoReference]?, description: MgoCodeableConcept?, expressedBy: MgoReference?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, profile: ZibTreatmentObjectiveProfile, referenceID: String, resourceType: String, subject: MgoReference?, target: Target) {
        self.addresses = addresses
        self.description = description
        self.expressedBy = expressedBy
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.target = target
    }
}

// MARK: ZibTreatmentObjective convenience initializers and mutators

public extension ZibTreatmentObjective {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTreatmentObjective.self, from: data)
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
        addresses: [MgoReference]?? = nil,
        description: MgoCodeableConcept?? = nil,
        expressedBy: MgoReference?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        profile: ZibTreatmentObjectiveProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil,
        target: Target? = nil
    ) -> ZibTreatmentObjective {
        return ZibTreatmentObjective(
            addresses: addresses ?? self.addresses,
            description: description ?? self.description,
            expressedBy: expressedBy ?? self.expressedBy,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject,
            target: target ?? self.target
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
