// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAllergyIntolerance = try ZibAllergyIntolerance(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAllergyIntolerance
public struct ZibAllergyIntolerance: Codable, Hashable, Sendable {
    public let category: [CategoryElement]?
    public let clinicalStatus: ZibAllergyIntoleranceClinicalStatus
    public let code: MgoCodeableConcept?
    public let criticality: Criticality
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let lastOccurrence: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let note: [MgoAnnotation]?
    public let onsetDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let patient: MgoReference?
    public let profile: ZibAllergyIntoleranceProfile
    public let reaction: [Reaction]?
    public let recorder: MgoReference?
    public let referenceID, resourceType: String
    public let source: MgoReference?
    public let verificationStatus: MgoCodeOfEnteredInErrorUnconfirmedConfirmedRefuted?

    public enum CodingKeys: String, CodingKey {
        case category, clinicalStatus, code, criticality, fhirVersion, id, identifier, lastOccurrence, note, onsetDateTime, patient, profile, reaction, recorder
        case referenceID = "referenceId"
        case resourceType, source, verificationStatus
    }

    public init(category: [CategoryElement]?, clinicalStatus: ZibAllergyIntoleranceClinicalStatus, code: MgoCodeableConcept?, criticality: Criticality, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, lastOccurrence: PrimitiveValueTypeOfDateTimeDateTimeString?, note: [MgoAnnotation]?, onsetDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, patient: MgoReference?, profile: ZibAllergyIntoleranceProfile, reaction: [Reaction]?, recorder: MgoReference?, referenceID: String, resourceType: String, source: MgoReference?, verificationStatus: MgoCodeOfEnteredInErrorUnconfirmedConfirmedRefuted?) {
        self.category = category
        self.clinicalStatus = clinicalStatus
        self.code = code
        self.criticality = criticality
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.lastOccurrence = lastOccurrence
        self.note = note
        self.onsetDateTime = onsetDateTime
        self.patient = patient
        self.profile = profile
        self.reaction = reaction
        self.recorder = recorder
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.source = source
        self.verificationStatus = verificationStatus
    }
}

// MARK: ZibAllergyIntolerance convenience initializers and mutators

public extension ZibAllergyIntolerance {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAllergyIntolerance.self, from: data)
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
        category: [CategoryElement]?? = nil,
        clinicalStatus: ZibAllergyIntoleranceClinicalStatus? = nil,
        code: MgoCodeableConcept?? = nil,
        criticality: Criticality? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        lastOccurrence: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        note: [MgoAnnotation]?? = nil,
        onsetDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        patient: MgoReference?? = nil,
        profile: ZibAllergyIntoleranceProfile? = nil,
        reaction: [Reaction]?? = nil,
        recorder: MgoReference?? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        source: MgoReference?? = nil,
        verificationStatus: MgoCodeOfEnteredInErrorUnconfirmedConfirmedRefuted?? = nil
    ) -> ZibAllergyIntolerance {
        return ZibAllergyIntolerance(
            category: category ?? self.category,
            clinicalStatus: clinicalStatus ?? self.clinicalStatus,
            code: code ?? self.code,
            criticality: criticality ?? self.criticality,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            lastOccurrence: lastOccurrence ?? self.lastOccurrence,
            note: note ?? self.note,
            onsetDateTime: onsetDateTime ?? self.onsetDateTime,
            patient: patient ?? self.patient,
            profile: profile ?? self.profile,
            reaction: reaction ?? self.reaction,
            recorder: recorder ?? self.recorder,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            source: source ?? self.source,
            verificationStatus: verificationStatus ?? self.verificationStatus
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
