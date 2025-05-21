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
    public let abatementDateTime, assertedDate: String?
    public let asserter: MgoReference?
    public let bodySite, category: [MgoCodeableConcept]?
    public let clinicalStatus: ZibProblemClinicalStatus?
    public let code: MgoCodeableConcept?
    public let context: MgoReference?
    public let evidence: [Evidence]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let note: [MgoAnnotation]?
    public let onsetDateTime: String?
    public let profile: ZibProblemProfile
    public let referenceID: String
    public let resourceType: String?
    public let severity: MgoCodeableConcept?
    public let stage: Stage
    public let subject: MgoReference?
    public let verificationStatus: ZibProblemVerificationStatus?

    public enum CodingKeys: String, CodingKey {
        case abatementDateTime, assertedDate, asserter, bodySite, category, clinicalStatus, code, context, evidence, fhirVersion, id, identifier, note, onsetDateTime, profile
        case referenceID = "referenceId"
        case resourceType, severity, stage, subject, verificationStatus
    }

    public init(abatementDateTime: String?, assertedDate: String?, asserter: MgoReference?, bodySite: [MgoCodeableConcept]?, category: [MgoCodeableConcept]?, clinicalStatus: ZibProblemClinicalStatus?, code: MgoCodeableConcept?, context: MgoReference?, evidence: [Evidence]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, note: [MgoAnnotation]?, onsetDateTime: String?, profile: ZibProblemProfile, referenceID: String, resourceType: String?, severity: MgoCodeableConcept?, stage: Stage, subject: MgoReference?, verificationStatus: ZibProblemVerificationStatus?) {
        self.abatementDateTime = abatementDateTime
        self.assertedDate = assertedDate
        self.asserter = asserter
        self.bodySite = bodySite
        self.category = category
        self.clinicalStatus = clinicalStatus
        self.code = code
        self.context = context
        self.evidence = evidence
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.note = note
        self.onsetDateTime = onsetDateTime
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.severity = severity
        self.stage = stage
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
        abatementDateTime: String?? = nil,
        assertedDate: String?? = nil,
        asserter: MgoReference?? = nil,
        bodySite: [MgoCodeableConcept]?? = nil,
        category: [MgoCodeableConcept]?? = nil,
        clinicalStatus: ZibProblemClinicalStatus?? = nil,
        code: MgoCodeableConcept?? = nil,
        context: MgoReference?? = nil,
        evidence: [Evidence]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        note: [MgoAnnotation]?? = nil,
        onsetDateTime: String?? = nil,
        profile: ZibProblemProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        severity: MgoCodeableConcept?? = nil,
        stage: Stage? = nil,
        subject: MgoReference?? = nil,
        verificationStatus: ZibProblemVerificationStatus?? = nil
    ) -> ZibProblem {
        return ZibProblem(
            abatementDateTime: abatementDateTime ?? self.abatementDateTime,
            assertedDate: assertedDate ?? self.assertedDate,
            asserter: asserter ?? self.asserter,
            bodySite: bodySite ?? self.bodySite,
            category: category ?? self.category,
            clinicalStatus: clinicalStatus ?? self.clinicalStatus,
            code: code ?? self.code,
            context: context ?? self.context,
            evidence: evidence ?? self.evidence,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            note: note ?? self.note,
            onsetDateTime: onsetDateTime ?? self.onsetDateTime,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            severity: severity ?? self.severity,
            stage: stage ?? self.stage,
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
