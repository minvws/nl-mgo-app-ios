// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpDiagnosticResult = try GpDiagnosticResult(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpDiagnosticResult
public struct GpDiagnosticResult: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let comment: String?
    public let context: MgoReference?
    public let effective: String?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: MgoCodeableConcept?
    public let performer: [MgoReference]?
    public let profile: GpDiagnosticResultProfile
    public let referenceID: String
    public let resourceType, status: String?
    public let subject: MgoReference?
    public let valueBoolean: Bool?
    public let valueCodeableConcept: MgoCodeableConcept?
    public let valueDateTime: String?
    public let valuePeriod: MgoPeriod?
    public let valueQuantity: MgoDuration?
    public let valueRange: MgoRange?
    public let valueString: String?

    public enum CodingKeys: String, CodingKey {
        case code, comment, context, effective, fhirVersion, id, identifier, method, performer, profile
        case referenceID = "referenceId"
        case resourceType, status, subject, valueBoolean, valueCodeableConcept, valueDateTime, valuePeriod, valueQuantity, valueRange, valueString
    }

    public init(code: MgoCodeableConcept?, comment: String?, context: MgoReference?, effective: String?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, method: MgoCodeableConcept?, performer: [MgoReference]?, profile: GpDiagnosticResultProfile, referenceID: String, resourceType: String?, status: String?, subject: MgoReference?, valueBoolean: Bool?, valueCodeableConcept: MgoCodeableConcept?, valueDateTime: String?, valuePeriod: MgoPeriod?, valueQuantity: MgoDuration?, valueRange: MgoRange?, valueString: String?) {
        self.code = code
        self.comment = comment
        self.context = context
        self.effective = effective
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.method = method
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
        self.valueBoolean = valueBoolean
        self.valueCodeableConcept = valueCodeableConcept
        self.valueDateTime = valueDateTime
        self.valuePeriod = valuePeriod
        self.valueQuantity = valueQuantity
        self.valueRange = valueRange
        self.valueString = valueString
    }
}

// MARK: GpDiagnosticResult convenience initializers and mutators

public extension GpDiagnosticResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpDiagnosticResult.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        comment: String?? = nil,
        context: MgoReference?? = nil,
        effective: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: MgoCodeableConcept?? = nil,
        performer: [MgoReference]?? = nil,
        profile: GpDiagnosticResultProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: String?? = nil,
        subject: MgoReference?? = nil,
        valueBoolean: Bool?? = nil,
        valueCodeableConcept: MgoCodeableConcept?? = nil,
        valueDateTime: String?? = nil,
        valuePeriod: MgoPeriod?? = nil,
        valueQuantity: MgoDuration?? = nil,
        valueRange: MgoRange?? = nil,
        valueString: String?? = nil
    ) -> GpDiagnosticResult {
        return GpDiagnosticResult(
            code: code ?? self.code,
            comment: comment ?? self.comment,
            context: context ?? self.context,
            effective: effective ?? self.effective,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            valueBoolean: valueBoolean ?? self.valueBoolean,
            valueCodeableConcept: valueCodeableConcept ?? self.valueCodeableConcept,
            valueDateTime: valueDateTime ?? self.valueDateTime,
            valuePeriod: valuePeriod ?? self.valuePeriod,
            valueQuantity: valueQuantity ?? self.valueQuantity,
            valueRange: valueRange ?? self.valueRange,
            valueString: valueString ?? self.valueString
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
