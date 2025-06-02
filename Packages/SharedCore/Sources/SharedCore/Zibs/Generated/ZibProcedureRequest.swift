// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibProcedureRequest = try ZibProcedureRequest(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProcedureRequest
public struct ZibProcedureRequest: Codable, Hashable, Sendable {
    public let bodySite: [ZibProcedureRequestBodySite]?
    public let code: MgoCodeableConcept?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let occurrenceDateTime: MgoDateTime?
    public let occurrencePeriod: MgoPeriod?
    public let occurrenceTiming: MgoTiming?
    public let performer: MgoReference?
    public let performerType: ZibProcedureRequestPerformerType
    public let profile: ZibProcedureRequestProfile
    public let reasonReference: [MgoReference]?
    public let referenceID: String
    public let requester: Requester
    public let resourceType: String
    public let status: ZibProcedureRequestStatus
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case bodySite, code, fhirVersion, id, identifier, occurrenceDateTime, occurrencePeriod, occurrenceTiming, performer, performerType, profile, reasonReference
        case referenceID = "referenceId"
        case requester, resourceType, status, subject
    }

    public init(bodySite: [ZibProcedureRequestBodySite]?, code: MgoCodeableConcept?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, occurrenceDateTime: MgoDateTime?, occurrencePeriod: MgoPeriod?, occurrenceTiming: MgoTiming?, performer: MgoReference?, performerType: ZibProcedureRequestPerformerType, profile: ZibProcedureRequestProfile, reasonReference: [MgoReference]?, referenceID: String, requester: Requester, resourceType: String, status: ZibProcedureRequestStatus, subject: MgoReference?) {
        self.bodySite = bodySite
        self.code = code
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.occurrenceDateTime = occurrenceDateTime
        self.occurrencePeriod = occurrencePeriod
        self.occurrenceTiming = occurrenceTiming
        self.performer = performer
        self.performerType = performerType
        self.profile = profile
        self.reasonReference = reasonReference
        self.referenceID = referenceID
        self.requester = requester
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
    }
}

// MARK: ZibProcedureRequest convenience initializers and mutators

public extension ZibProcedureRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibProcedureRequest.self, from: data)
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
        bodySite: [ZibProcedureRequestBodySite]?? = nil,
        code: MgoCodeableConcept?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        occurrenceDateTime: MgoDateTime?? = nil,
        occurrencePeriod: MgoPeriod?? = nil,
        occurrenceTiming: MgoTiming?? = nil,
        performer: MgoReference?? = nil,
        performerType: ZibProcedureRequestPerformerType? = nil,
        profile: ZibProcedureRequestProfile? = nil,
        reasonReference: [MgoReference]?? = nil,
        referenceID: String? = nil,
        requester: Requester? = nil,
        resourceType: String? = nil,
        status: ZibProcedureRequestStatus? = nil,
        subject: MgoReference?? = nil
    ) -> ZibProcedureRequest {
        return ZibProcedureRequest(
            bodySite: bodySite ?? self.bodySite,
            code: code ?? self.code,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            occurrenceDateTime: occurrenceDateTime ?? self.occurrenceDateTime,
            occurrencePeriod: occurrencePeriod ?? self.occurrencePeriod,
            occurrenceTiming: occurrenceTiming ?? self.occurrenceTiming,
            performer: performer ?? self.performer,
            performerType: performerType ?? self.performerType,
            profile: profile ?? self.profile,
            reasonReference: reasonReference ?? self.reasonReference,
            referenceID: referenceID ?? self.referenceID,
            requester: requester ?? self.requester,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
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
