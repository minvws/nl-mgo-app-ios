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
    public let doseQuantity: MgoQuantity?
    public let fhirVersion: FhirVersionR4
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let location: MgoReference?
    public let note: [MgoAnnotation]?
    public let occurrenceDateTime: MgoDateTime?
    public let occurrenceString: MgoString?
    public let patient: MgoReference?
    public let performer: [R4NlCoreVaccinationEventPerformer]?
    public let pharmaceuticalProduct: PharmaceuticalProduct?
    public let profile: R4NlCoreVaccinationEventProfile
    public let protocolApplied: [ProtocolApplied]?
    public let reasonCode: ReasonCode
    public let referenceID, resourceType: String
    public let route: MgoCodeableConcept?
    public let status: MgoString?
    public let vaccineCode: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case doseQuantity, fhirVersion, id, identifier, location, note, occurrenceDateTime, occurrenceString, patient, performer, pharmaceuticalProduct, profile, protocolApplied, reasonCode
        case referenceID = "referenceId"
        case resourceType, route, status, vaccineCode
    }

    public init(doseQuantity: MgoQuantity?, fhirVersion: FhirVersionR4, id: String?, identifier: [MgoIdentifier]?, location: MgoReference?, note: [MgoAnnotation]?, occurrenceDateTime: MgoDateTime?, occurrenceString: MgoString?, patient: MgoReference?, performer: [R4NlCoreVaccinationEventPerformer]?, pharmaceuticalProduct: PharmaceuticalProduct?, profile: R4NlCoreVaccinationEventProfile, protocolApplied: [ProtocolApplied]?, reasonCode: ReasonCode, referenceID: String, resourceType: String, route: MgoCodeableConcept?, status: MgoString?, vaccineCode: MgoCodeableConcept?) {
        self.doseQuantity = doseQuantity
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.location = location
        self.note = note
        self.occurrenceDateTime = occurrenceDateTime
        self.occurrenceString = occurrenceString
        self.patient = patient
        self.performer = performer
        self.pharmaceuticalProduct = pharmaceuticalProduct
        self.profile = profile
        self.protocolApplied = protocolApplied
        self.reasonCode = reasonCode
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.route = route
        self.status = status
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
        doseQuantity: MgoQuantity?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        location: MgoReference?? = nil,
        note: [MgoAnnotation]?? = nil,
        occurrenceDateTime: MgoDateTime?? = nil,
        occurrenceString: MgoString?? = nil,
        patient: MgoReference?? = nil,
        performer: [R4NlCoreVaccinationEventPerformer]?? = nil,
        pharmaceuticalProduct: PharmaceuticalProduct?? = nil,
        profile: R4NlCoreVaccinationEventProfile? = nil,
        protocolApplied: [ProtocolApplied]?? = nil,
        reasonCode: ReasonCode? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        route: MgoCodeableConcept?? = nil,
        status: MgoString?? = nil,
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
            occurrenceString: occurrenceString ?? self.occurrenceString,
            patient: patient ?? self.patient,
            performer: performer ?? self.performer,
            pharmaceuticalProduct: pharmaceuticalProduct ?? self.pharmaceuticalProduct,
            profile: profile ?? self.profile,
            protocolApplied: protocolApplied ?? self.protocolApplied,
            reasonCode: reasonCode ?? self.reasonCode,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            route: route ?? self.route,
            status: status ?? self.status,
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
