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
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let intent: MgoCodeableConcept?
    public let occurrence: MgoPeriod?
    public let perfomer: MgoReference?
    public let profile: ZibMedicalDeviceRequestProfile
    public let referenceID: String
    public let resourceType, status: String?
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case codeCodeableConcept, codeReference, fhirVersion, id, intent, occurrence, perfomer, profile
        case referenceID = "referenceId"
        case resourceType, status, subject
    }

    public init(codeCodeableConcept: MgoCodeableConcept?, codeReference: MgoReference?, fhirVersion: FhirVersionR3, id: String?, intent: MgoCodeableConcept?, occurrence: MgoPeriod?, perfomer: MgoReference?, profile: ZibMedicalDeviceRequestProfile, referenceID: String, resourceType: String?, status: String?, subject: MgoReference?) {
        self.codeCodeableConcept = codeCodeableConcept
        self.codeReference = codeReference
        self.fhirVersion = fhirVersion
        self.id = id
        self.intent = intent
        self.occurrence = occurrence
        self.perfomer = perfomer
        self.profile = profile
        self.referenceID = referenceID
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
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        intent: MgoCodeableConcept?? = nil,
        occurrence: MgoPeriod?? = nil,
        perfomer: MgoReference?? = nil,
        profile: ZibMedicalDeviceRequestProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: String?? = nil,
        subject: MgoReference?? = nil
    ) -> ZibMedicalDeviceRequest {
        return ZibMedicalDeviceRequest(
            codeCodeableConcept: codeCodeableConcept ?? self.codeCodeableConcept,
            codeReference: codeReference ?? self.codeReference,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            intent: intent ?? self.intent,
            occurrence: occurrence ?? self.occurrence,
            perfomer: perfomer ?? self.perfomer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
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
