// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreVaccinationEvent = try R4NlCoreVaccinationEvent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreVaccinationEvent
public struct R4NlCoreVaccinationEvent: Codable, Hashable, Sendable {
    public let doseQuantity: MgoDuration?
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let location: MgoReference?
    public let note: [MgoAnnotation]?
    public let occurrenceDateTime: String?
    public let patient: MgoReference?
    public let performer: [MgoReference]?
    public let pharmaceuticalProduct: MgoReference?
    public let profile: R4NlCoreVaccinationEventProfile
    public let protocolApplied: [ProtocolApplied]?
    public let referenceID: String
    public let resourceType: String?
    public let route, site: MgoCodeableConcept?
    public let status: String?
    public let vaccinationIndication, vaccinationMotive: [MgoCodeableConcept]?
    public let vaccineCode: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case doseQuantity, fhirVersion, id, identifier, location, note, occurrenceDateTime, patient, performer, pharmaceuticalProduct, profile, protocolApplied
        case referenceID = "referenceId"
        case resourceType, route, site, status, vaccinationIndication, vaccinationMotive, vaccineCode
    }

    public init(doseQuantity: MgoDuration?, fhirVersion: FhirVersionR4, id: String?, identifier: [MgoIdentifier]?, location: MgoReference?, note: [MgoAnnotation]?, occurrenceDateTime: String?, patient: MgoReference?, performer: [MgoReference]?, pharmaceuticalProduct: MgoReference?, profile: R4NlCoreVaccinationEventProfile, protocolApplied: [ProtocolApplied]?, referenceID: String, resourceType: String?, route: MgoCodeableConcept?, site: MgoCodeableConcept?, status: String?, vaccinationIndication: [MgoCodeableConcept]?, vaccinationMotive: [MgoCodeableConcept]?, vaccineCode: MgoCodeableConcept?) {
        self.doseQuantity = doseQuantity
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.location = location
        self.note = note
        self.occurrenceDateTime = occurrenceDateTime
        self.patient = patient
        self.performer = performer
        self.pharmaceuticalProduct = pharmaceuticalProduct
        self.profile = profile
        self.protocolApplied = protocolApplied
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.route = route
        self.site = site
        self.status = status
        self.vaccinationIndication = vaccinationIndication
        self.vaccinationMotive = vaccinationMotive
        self.vaccineCode = vaccineCode
    }
}

// MARK: R4NlCoreVaccinationEvent convenience initializers and mutators

public extension R4NlCoreVaccinationEvent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreVaccinationEvent.self, from: data)
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
        doseQuantity: MgoDuration?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        location: MgoReference?? = nil,
        note: [MgoAnnotation]?? = nil,
        occurrenceDateTime: String?? = nil,
        patient: MgoReference?? = nil,
        performer: [MgoReference]?? = nil,
        pharmaceuticalProduct: MgoReference?? = nil,
        profile: R4NlCoreVaccinationEventProfile? = nil,
        protocolApplied: [ProtocolApplied]?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        route: MgoCodeableConcept?? = nil,
        site: MgoCodeableConcept?? = nil,
        status: String?? = nil,
        vaccinationIndication: [MgoCodeableConcept]?? = nil,
        vaccinationMotive: [MgoCodeableConcept]?? = nil,
        vaccineCode: MgoCodeableConcept?? = nil
    ) -> R4NlCoreVaccinationEvent {
        return R4NlCoreVaccinationEvent(
            doseQuantity: doseQuantity ?? self.doseQuantity,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            location: location ?? self.location,
            note: note ?? self.note,
            occurrenceDateTime: occurrenceDateTime ?? self.occurrenceDateTime,
            patient: patient ?? self.patient,
            performer: performer ?? self.performer,
            pharmaceuticalProduct: pharmaceuticalProduct ?? self.pharmaceuticalProduct,
            profile: profile ?? self.profile,
            protocolApplied: protocolApplied ?? self.protocolApplied,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            route: route ?? self.route,
            site: site ?? self.site,
            status: status ?? self.status,
            vaccinationIndication: vaccinationIndication ?? self.vaccinationIndication,
            vaccinationMotive: vaccinationMotive ?? self.vaccinationMotive,
            vaccineCode: vaccineCode ?? self.vaccineCode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
