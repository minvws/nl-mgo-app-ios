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
    public let basedOn: [MgoReference]?
    public let bodySite: [ZibProcedureBodySite]?
    public let code: MgoCodeableConcept?
    public let fhirVersion: FhirVersionR3
    public let focalDevice: [FocalDevice]?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let location: MgoReference?
    public let performedPeriod: MgoPeriod?
    public let performer: [ZibProcedurePerformer]?
    public let procedureMethod: ProcedureMethod?
    public let profile: ZibProcedureProfile
    public let reasonReference: [MgoReference]?
    public let referenceID: String
    public let report: [MgoReference]?
    public let resourceType: String
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case basedOn, bodySite, code, fhirVersion, focalDevice, id, identifier, location, performedPeriod, performer, procedureMethod, profile, reasonReference
        case referenceID = "referenceId"
        case report, resourceType, subject
    }

    public init(basedOn: [MgoReference]?, bodySite: [ZibProcedureBodySite]?, code: MgoCodeableConcept?, fhirVersion: FhirVersionR3, focalDevice: [FocalDevice]?, id: String?, identifier: [MgoIdentifier]?, location: MgoReference?, performedPeriod: MgoPeriod?, performer: [ZibProcedurePerformer]?, procedureMethod: ProcedureMethod?, profile: ZibProcedureProfile, reasonReference: [MgoReference]?, referenceID: String, report: [MgoReference]?, resourceType: String, subject: MgoReference?) {
        self.basedOn = basedOn
        self.bodySite = bodySite
        self.code = code
        self.fhirVersion = fhirVersion
        self.focalDevice = focalDevice
        self.id = id
        self.identifier = identifier
        self.location = location
        self.performedPeriod = performedPeriod
        self.performer = performer
        self.procedureMethod = procedureMethod
        self.profile = profile
        self.reasonReference = reasonReference
        self.referenceID = referenceID
        self.report = report
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
        basedOn: [MgoReference]?? = nil,
        bodySite: [ZibProcedureBodySite]?? = nil,
        code: MgoCodeableConcept?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        focalDevice: [FocalDevice]?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        location: MgoReference?? = nil,
        performedPeriod: MgoPeriod?? = nil,
        performer: [ZibProcedurePerformer]?? = nil,
        procedureMethod: ProcedureMethod?? = nil,
        profile: ZibProcedureProfile? = nil,
        reasonReference: [MgoReference]?? = nil,
        referenceID: String? = nil,
        report: [MgoReference]?? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil
    ) -> ZibProcedure {
        return ZibProcedure(
            basedOn: basedOn ?? self.basedOn,
            bodySite: bodySite ?? self.bodySite,
            code: code ?? self.code,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            focalDevice: focalDevice ?? self.focalDevice,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            location: location ?? self.location,
            performedPeriod: performedPeriod ?? self.performedPeriod,
            performer: performer ?? self.performer,
            procedureMethod: procedureMethod ?? self.procedureMethod,
            profile: profile ?? self.profile,
            reasonReference: reasonReference ?? self.reasonReference,
            referenceID: referenceID ?? self.referenceID,
            report: report ?? self.report,
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
