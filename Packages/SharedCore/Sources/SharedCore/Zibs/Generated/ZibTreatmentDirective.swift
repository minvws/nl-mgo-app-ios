// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTreatmentDirective = try ZibTreatmentDirective(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTreatmentDirective
public struct ZibTreatmentDirective: Codable, Hashable, Sendable {
    public let action: [MgoCodeableConcept]?
    public let actor: [ZibTreatmentDirectiveActor]?
    public let category: [MgoCodeableConcept]?
    public let consentingParty: [MgoReference]?
    public let data: [ZibTreatmentDirectiveDatum]?
    public let dataPeriod: MgoPeriod?
    public let dateTime: String?
    public let except: [Except]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: MgoIdentifier?
    public let organization: [MgoReference]?
    public let patient: MgoReference?
    public let period: MgoPeriod?
    public let policy: [Policy]?
    public let policyRule: String?
    public let profile: ZibTreatmentDirectiveProfile
    public let purpose: [MgoCoding]?
    public let referenceID: String
    public let resourceType: String?
    public let securityLabel: [MgoCoding]?
    public let sourceAttachment: Attachment
    public let sourceIdentifier: MgoIdentifier?
    public let sourceReference: MgoReference?
    public let status: ZibTreatmentDirectiveStatus?

    public enum CodingKeys: String, CodingKey {
        case action, actor, category, consentingParty, data, dataPeriod, dateTime, except, fhirVersion, id, identifier, organization, patient, period, policy, policyRule, profile, purpose
        case referenceID = "referenceId"
        case resourceType, securityLabel, sourceAttachment, sourceIdentifier, sourceReference, status
    }

    public init(action: [MgoCodeableConcept]?, actor: [ZibTreatmentDirectiveActor]?, category: [MgoCodeableConcept]?, consentingParty: [MgoReference]?, data: [ZibTreatmentDirectiveDatum]?, dataPeriod: MgoPeriod?, dateTime: String?, except: [Except]?, fhirVersion: FhirVersionR3, id: String?, identifier: MgoIdentifier?, organization: [MgoReference]?, patient: MgoReference?, period: MgoPeriod?, policy: [Policy]?, policyRule: String?, profile: ZibTreatmentDirectiveProfile, purpose: [MgoCoding]?, referenceID: String, resourceType: String?, securityLabel: [MgoCoding]?, sourceAttachment: Attachment, sourceIdentifier: MgoIdentifier?, sourceReference: MgoReference?, status: ZibTreatmentDirectiveStatus?) {
        self.action = action
        self.actor = actor
        self.category = category
        self.consentingParty = consentingParty
        self.data = data
        self.dataPeriod = dataPeriod
        self.dateTime = dateTime
        self.except = except
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.organization = organization
        self.patient = patient
        self.period = period
        self.policy = policy
        self.policyRule = policyRule
        self.profile = profile
        self.purpose = purpose
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.securityLabel = securityLabel
        self.sourceAttachment = sourceAttachment
        self.sourceIdentifier = sourceIdentifier
        self.sourceReference = sourceReference
        self.status = status
    }
}

// MARK: ZibTreatmentDirective convenience initializers and mutators

public extension ZibTreatmentDirective {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTreatmentDirective.self, from: data)
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
        action: [MgoCodeableConcept]?? = nil,
        actor: [ZibTreatmentDirectiveActor]?? = nil,
        category: [MgoCodeableConcept]?? = nil,
        consentingParty: [MgoReference]?? = nil,
        data: [ZibTreatmentDirectiveDatum]?? = nil,
        dataPeriod: MgoPeriod?? = nil,
        dateTime: String?? = nil,
        except: [Except]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: MgoIdentifier?? = nil,
        organization: [MgoReference]?? = nil,
        patient: MgoReference?? = nil,
        period: MgoPeriod?? = nil,
        policy: [Policy]?? = nil,
        policyRule: String?? = nil,
        profile: ZibTreatmentDirectiveProfile? = nil,
        purpose: [MgoCoding]?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        securityLabel: [MgoCoding]?? = nil,
        sourceAttachment: Attachment? = nil,
        sourceIdentifier: MgoIdentifier?? = nil,
        sourceReference: MgoReference?? = nil,
        status: ZibTreatmentDirectiveStatus?? = nil
    ) -> ZibTreatmentDirective {
        return ZibTreatmentDirective(
            action: action ?? self.action,
            actor: actor ?? self.actor,
            category: category ?? self.category,
            consentingParty: consentingParty ?? self.consentingParty,
            data: data ?? self.data,
            dataPeriod: dataPeriod ?? self.dataPeriod,
            dateTime: dateTime ?? self.dateTime,
            except: except ?? self.except,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            organization: organization ?? self.organization,
            patient: patient ?? self.patient,
            period: period ?? self.period,
            policy: policy ?? self.policy,
            policyRule: policyRule ?? self.policyRule,
            profile: profile ?? self.profile,
            purpose: purpose ?? self.purpose,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            securityLabel: securityLabel ?? self.securityLabel,
            sourceAttachment: sourceAttachment ?? self.sourceAttachment,
            sourceIdentifier: sourceIdentifier ?? self.sourceIdentifier,
            sourceReference: sourceReference ?? self.sourceReference,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
