// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAdvanceDirective = try ZibAdvanceDirective(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAdvanceDirective
public struct ZibAdvanceDirective: Codable, Hashable, Sendable {
    public let category: ZibAdvanceDirectiveCategory
    public let comment: ZibAdvanceDirectiveComment?
    public let consentingParty: MgoReference?
    public let dateTime: MgoDateTime?
    public let disorder: [Disorder]
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: MgoIdentifier?
    public let profile: ZibAdvanceDirectiveProfile
    public let referenceID, resourceType: String
    public let sourceAttachment: MgoAttachment?
    public let sourceIdentifier: MgoIdentifier?
    public let sourceReference: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case category, comment, consentingParty, dateTime, disorder, fhirVersion, id, identifier, profile
        case referenceID = "referenceId"
        case resourceType, sourceAttachment, sourceIdentifier, sourceReference
    }

    public init(category: ZibAdvanceDirectiveCategory, comment: ZibAdvanceDirectiveComment?, consentingParty: MgoReference?, dateTime: MgoDateTime?, disorder: [Disorder], fhirVersion: FhirVersionR3, id: String?, identifier: MgoIdentifier?, profile: ZibAdvanceDirectiveProfile, referenceID: String, resourceType: String, sourceAttachment: MgoAttachment?, sourceIdentifier: MgoIdentifier?, sourceReference: MgoReference?) {
        self.category = category
        self.comment = comment
        self.consentingParty = consentingParty
        self.dateTime = dateTime
        self.disorder = disorder
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.sourceAttachment = sourceAttachment
        self.sourceIdentifier = sourceIdentifier
        self.sourceReference = sourceReference
    }
}

// MARK: ZibAdvanceDirective convenience initializers and mutators

public extension ZibAdvanceDirective {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAdvanceDirective.self, from: data)
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
        category: ZibAdvanceDirectiveCategory? = nil,
        comment: ZibAdvanceDirectiveComment?? = nil,
        consentingParty: MgoReference?? = nil,
        dateTime: MgoDateTime?? = nil,
        disorder: [Disorder]? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: MgoIdentifier?? = nil,
        profile: ZibAdvanceDirectiveProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        sourceAttachment: MgoAttachment?? = nil,
        sourceIdentifier: MgoIdentifier?? = nil,
        sourceReference: MgoReference?? = nil
    ) -> ZibAdvanceDirective {
        return ZibAdvanceDirective(
            category: category ?? self.category,
            comment: comment ?? self.comment,
            consentingParty: consentingParty ?? self.consentingParty,
            dateTime: dateTime ?? self.dateTime,
            disorder: disorder ?? self.disorder,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            sourceAttachment: sourceAttachment ?? self.sourceAttachment,
            sourceIdentifier: sourceIdentifier ?? self.sourceIdentifier,
            sourceReference: sourceReference ?? self.sourceReference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
