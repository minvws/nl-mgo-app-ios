// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTobaccoUse = try ZibTobaccoUse(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTobaccoUse
public struct ZibTobaccoUse: Codable, Hashable, Sendable {
    public let bodySite: [MgoCoding]?
    public let category: [[MgoCoding]]?
    public let comment: String?
    public let context: MgoReference?
    public let dataAbsentReason: [MgoCoding]?
    public let effectivePeriod: MgoPeriod?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let method: [MgoCoding]?
    public let profile: ZibTobaccoUseProfile
    public let referenceID: String
    public let resourceType, status: String?
    public let subject: MgoReference?
    public let valueQuantity: MgoDuration?

    public enum CodingKeys: String, CodingKey {
        case bodySite, category, comment, context, dataAbsentReason, effectivePeriod, id, identifier, method, profile
        case referenceID = "referenceId"
        case resourceType, status, subject, valueQuantity
    }

    public init(bodySite: [MgoCoding]?, category: [[MgoCoding]]?, comment: String?, context: MgoReference?, dataAbsentReason: [MgoCoding]?, effectivePeriod: MgoPeriod?, id: String?, identifier: [MgoIdentifier]?, method: [MgoCoding]?, profile: ZibTobaccoUseProfile, referenceID: String, resourceType: String?, status: String?, subject: MgoReference?, valueQuantity: MgoDuration?) {
        self.bodySite = bodySite
        self.category = category
        self.comment = comment
        self.context = context
        self.dataAbsentReason = dataAbsentReason
        self.effectivePeriod = effectivePeriod
        self.id = id
        self.identifier = identifier
        self.method = method
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
        self.valueQuantity = valueQuantity
    }
}

// MARK: ZibTobaccoUse convenience initializers and mutators

public extension ZibTobaccoUse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTobaccoUse.self, from: data)
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
        bodySite: [MgoCoding]?? = nil,
        category: [[MgoCoding]]?? = nil,
        comment: String?? = nil,
        context: MgoReference?? = nil,
        dataAbsentReason: [MgoCoding]?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        method: [MgoCoding]?? = nil,
        profile: ZibTobaccoUseProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: String?? = nil,
        subject: MgoReference?? = nil,
        valueQuantity: MgoDuration?? = nil
    ) -> ZibTobaccoUse {
        return ZibTobaccoUse(
            bodySite: bodySite ?? self.bodySite,
            category: category ?? self.category,
            comment: comment ?? self.comment,
            context: context ?? self.context,
            dataAbsentReason: dataAbsentReason ?? self.dataAbsentReason,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            method: method ?? self.method,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            valueQuantity: valueQuantity ?? self.valueQuantity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
