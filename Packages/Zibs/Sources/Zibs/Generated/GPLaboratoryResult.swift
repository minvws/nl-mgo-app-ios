// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpLaboratoryResult = try GpLaboratoryResult(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpLaboratoryResult
public struct GpLaboratoryResult: Codable, Hashable, Sendable {
    public let basedOn: [MgoReference]?
    public let category: [[MgoCoding]]?
    public let code: [MgoCoding]?
    public let comment: String?
    public let effective: Effective?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let interpretation, method: [MgoCoding]?
    public let profile: GpLaboratoryResultProfile
    public let referenceID: String
    public let referenceRange: [GpLaboratoryResultReferenceRange]?
    public let related: [GpLaboratoryResultRelated]?
    public let resourceType: String?
    public let result: MgoDuration?
    public let specimen: MgoReference?
    public let status: String?
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case basedOn, category, code, comment, effective, id, identifier, interpretation, method, profile
        case referenceID = "referenceId"
        case referenceRange, related, resourceType, result, specimen, status, subject
    }

    public init(basedOn: [MgoReference]?, category: [[MgoCoding]]?, code: [MgoCoding]?, comment: String?, effective: Effective?, id: String?, identifier: [MgoIdentifier]?, interpretation: [MgoCoding]?, method: [MgoCoding]?, profile: GpLaboratoryResultProfile, referenceID: String, referenceRange: [GpLaboratoryResultReferenceRange]?, related: [GpLaboratoryResultRelated]?, resourceType: String?, result: MgoDuration?, specimen: MgoReference?, status: String?, subject: MgoReference?) {
        self.basedOn = basedOn
        self.category = category
        self.code = code
        self.comment = comment
        self.effective = effective
        self.id = id
        self.identifier = identifier
        self.interpretation = interpretation
        self.method = method
        self.profile = profile
        self.referenceID = referenceID
        self.referenceRange = referenceRange
        self.related = related
        self.resourceType = resourceType
        self.result = result
        self.specimen = specimen
        self.status = status
        self.subject = subject
    }
}

// MARK: GpLaboratoryResult convenience initializers and mutators

public extension GpLaboratoryResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpLaboratoryResult.self, from: data)
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
        category: [[MgoCoding]]?? = nil,
        code: [MgoCoding]?? = nil,
        comment: String?? = nil,
        effective: Effective?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        interpretation: [MgoCoding]?? = nil,
        method: [MgoCoding]?? = nil,
        profile: GpLaboratoryResultProfile? = nil,
        referenceID: String? = nil,
        referenceRange: [GpLaboratoryResultReferenceRange]?? = nil,
        related: [GpLaboratoryResultRelated]?? = nil,
        resourceType: String?? = nil,
        result: MgoDuration?? = nil,
        specimen: MgoReference?? = nil,
        status: String?? = nil,
        subject: MgoReference?? = nil
    ) -> GpLaboratoryResult {
        return GpLaboratoryResult(
            basedOn: basedOn ?? self.basedOn,
            category: category ?? self.category,
            code: code ?? self.code,
            comment: comment ?? self.comment,
            effective: effective ?? self.effective,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            interpretation: interpretation ?? self.interpretation,
            method: method ?? self.method,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            referenceRange: referenceRange ?? self.referenceRange,
            related: related ?? self.related,
            resourceType: resourceType ?? self.resourceType,
            result: result ?? self.result,
            specimen: specimen ?? self.specimen,
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
