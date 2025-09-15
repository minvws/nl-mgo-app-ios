// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibMedicalDeviceRequest = try ZibMedicalDeviceRequest(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicalDeviceRequest
public struct ZibMedicalDeviceRequest: Codable, Hashable, Sendable {
    public let codeCodeableConcept: MgoCodeableConcept?
    public let codeReference: MgoReference?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let occurrenceDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let occurrencePeriod: MgoPeriod?
    public let occurrenceTiming: MgoTiming?
    public let performerType: ZibMedicalDeviceRequestPerformerType
    public let profile: ZibMedicalDeviceRequestProfile
    public let referenceID: String
    public let requester: MgoReference?
    public let resourceType: String
    public let status: ZibMedicalDeviceRequestStatus
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case codeCodeableConcept, codeReference, fhirVersion, id, identifier, occurrenceDateTime, occurrencePeriod, occurrenceTiming, performerType, profile
        case referenceID = "referenceId"
        case requester, resourceType, status, subject
    }

    public init(codeCodeableConcept: MgoCodeableConcept?, codeReference: MgoReference?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, occurrenceDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, occurrencePeriod: MgoPeriod?, occurrenceTiming: MgoTiming?, performerType: ZibMedicalDeviceRequestPerformerType, profile: ZibMedicalDeviceRequestProfile, referenceID: String, requester: MgoReference?, resourceType: String, status: ZibMedicalDeviceRequestStatus, subject: MgoReference?) {
        self.codeCodeableConcept = codeCodeableConcept
        self.codeReference = codeReference
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.occurrenceDateTime = occurrenceDateTime
        self.occurrencePeriod = occurrencePeriod
        self.occurrenceTiming = occurrenceTiming
        self.performerType = performerType
        self.profile = profile
        self.referenceID = referenceID
        self.requester = requester
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
    }
}

// MARK: ZibMedicalDeviceRequest convenience initializers and mutators

public extension ZibMedicalDeviceRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibMedicalDeviceRequest.self, from: data)
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
        codeCodeableConcept: MgoCodeableConcept?? = nil,
        codeReference: MgoReference?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        occurrenceDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        occurrencePeriod: MgoPeriod?? = nil,
        occurrenceTiming: MgoTiming?? = nil,
        performerType: ZibMedicalDeviceRequestPerformerType? = nil,
        profile: ZibMedicalDeviceRequestProfile? = nil,
        referenceID: String? = nil,
        requester: MgoReference?? = nil,
        resourceType: String? = nil,
        status: ZibMedicalDeviceRequestStatus? = nil,
        subject: MgoReference?? = nil
    ) -> ZibMedicalDeviceRequest {
        return ZibMedicalDeviceRequest(
            codeCodeableConcept: codeCodeableConcept ?? self.codeCodeableConcept,
            codeReference: codeReference ?? self.codeReference,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            occurrenceDateTime: occurrenceDateTime ?? self.occurrenceDateTime,
            occurrencePeriod: occurrencePeriod ?? self.occurrencePeriod,
            occurrenceTiming: occurrenceTiming ?? self.occurrenceTiming,
            performerType: performerType ?? self.performerType,
            profile: profile ?? self.profile,
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
