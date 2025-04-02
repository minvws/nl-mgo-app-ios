// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibProcedure = try ZibProcedure(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProcedure
public struct ZibProcedure: Codable, Hashable, Sendable {
    public let bodySite, bodySiteQualifier: [MgoCodeableConcept]?
    public let code: MgoCodeableConcept?
    public let fhirVersion: FhirVersionR3
    public let focalDevice: [FocalDevice]?
    public let id: String?
    public let location: MgoReference?
    public let performedPeriod: MgoPeriod?
    public let performer: [ZibProcedurePerformer]?
    public let procedureMethod: MgoCodeableConcept?
    public let profile: ZibProcedureProfile
    public let reasonReference: [MgoReference]?
    public let referenceID: String
    public let resourceType: String?
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case bodySite, bodySiteQualifier, code, fhirVersion, focalDevice, id, location, performedPeriod, performer, procedureMethod, profile, reasonReference
        case referenceID = "referenceId"
        case resourceType, subject
    }

    public init(bodySite: [MgoCodeableConcept]?, bodySiteQualifier: [MgoCodeableConcept]?, code: MgoCodeableConcept?, fhirVersion: FhirVersionR3, focalDevice: [FocalDevice]?, id: String?, location: MgoReference?, performedPeriod: MgoPeriod?, performer: [ZibProcedurePerformer]?, procedureMethod: MgoCodeableConcept?, profile: ZibProcedureProfile, reasonReference: [MgoReference]?, referenceID: String, resourceType: String?, subject: MgoReference?) {
        self.bodySite = bodySite
        self.bodySiteQualifier = bodySiteQualifier
        self.code = code
        self.fhirVersion = fhirVersion
        self.focalDevice = focalDevice
        self.id = id
        self.location = location
        self.performedPeriod = performedPeriod
        self.performer = performer
        self.procedureMethod = procedureMethod
        self.profile = profile
        self.reasonReference = reasonReference
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
    }
}

// MARK: ZibProcedure convenience initializers and mutators

public extension ZibProcedure {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibProcedure.self, from: data)
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
        bodySite: [MgoCodeableConcept]?? = nil,
        bodySiteQualifier: [MgoCodeableConcept]?? = nil,
        code: MgoCodeableConcept?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        focalDevice: [FocalDevice]?? = nil,
        id: String?? = nil,
        location: MgoReference?? = nil,
        performedPeriod: MgoPeriod?? = nil,
        performer: [ZibProcedurePerformer]?? = nil,
        procedureMethod: MgoCodeableConcept?? = nil,
        profile: ZibProcedureProfile? = nil,
        reasonReference: [MgoReference]?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        subject: MgoReference?? = nil
    ) -> ZibProcedure {
        return ZibProcedure(
            bodySite: bodySite ?? self.bodySite,
            bodySiteQualifier: bodySiteQualifier ?? self.bodySiteQualifier,
            code: code ?? self.code,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            focalDevice: focalDevice ?? self.focalDevice,
            id: id ?? self.id,
            location: location ?? self.location,
            performedPeriod: performedPeriod ?? self.performedPeriod,
            performer: performer ?? self.performer,
            procedureMethod: procedureMethod ?? self.procedureMethod,
            profile: profile ?? self.profile,
            reasonReference: reasonReference ?? self.reasonReference,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
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
