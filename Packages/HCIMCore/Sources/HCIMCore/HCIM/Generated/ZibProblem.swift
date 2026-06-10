// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibProblem = try ZibProblem(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProblem
public struct ZibProblem: Codable, Hashable, Sendable {
    public let abatementDateTime: MgoDateTime?
    public let asserter: MgoReference?
    public let bodySite: [ZibProblemBodySite]?
    public let category: [MgoCodeableConcept]?
    public let clinicalStatus: ZibProblemClinicalStatus
    public let code: MgoCodeableConcept?
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let note: [MgoAnnotation]?
    public let onsetDateTime: MgoDateTime?
    public let profile: ZibProblemProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?
    public let verificationStatus: VerificationStatus

    public enum CodingKeys: String, CodingKey {
        case abatementDateTime, asserter, bodySite, category, clinicalStatus, code, fhirVersion, id, identifier, note, onsetDateTime, profile
        case referenceID = "referenceId"
        case resourceType, subject, verificationStatus
    }

    public init(abatementDateTime: MgoDateTime?, asserter: MgoReference?, bodySite: [ZibProblemBodySite]?, category: [MgoCodeableConcept]?, clinicalStatus: ZibProblemClinicalStatus, code: MgoCodeableConcept?, fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, note: [MgoAnnotation]?, onsetDateTime: MgoDateTime?, profile: ZibProblemProfile, referenceID: String, resourceType: String, subject: MgoReference?, verificationStatus: VerificationStatus) {
        self.abatementDateTime = abatementDateTime
        self.asserter = asserter
        self.bodySite = bodySite
        self.category = category
        self.clinicalStatus = clinicalStatus
        self.code = code
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.note = note
        self.onsetDateTime = onsetDateTime
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.verificationStatus = verificationStatus
    }
}

// MARK: ZibProblem convenience initializers and mutators

public extension ZibProblem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibProblem.self, from: data)
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
        abatementDateTime: MgoDateTime?? = nil,
        asserter: MgoReference?? = nil,
        bodySite: [ZibProblemBodySite]?? = nil,
        category: [MgoCodeableConcept]?? = nil,
        clinicalStatus: ZibProblemClinicalStatus? = nil,
        code: MgoCodeableConcept?? = nil,
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        note: [MgoAnnotation]?? = nil,
        onsetDateTime: MgoDateTime?? = nil,
        profile: ZibProblemProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil,
        verificationStatus: VerificationStatus? = nil
    ) -> ZibProblem {
        return ZibProblem(
            abatementDateTime: abatementDateTime ?? self.abatementDateTime,
            asserter: asserter ?? self.asserter,
            bodySite: bodySite ?? self.bodySite,
            category: category ?? self.category,
            clinicalStatus: clinicalStatus ?? self.clinicalStatus,
            code: code ?? self.code,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            note: note ?? self.note,
            onsetDateTime: onsetDateTime ?? self.onsetDateTime,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject,
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
