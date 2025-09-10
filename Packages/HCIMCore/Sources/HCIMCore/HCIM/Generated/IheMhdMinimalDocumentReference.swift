// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let iheMhdMinimalDocumentReference = try IheMhdMinimalDocumentReference(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - IheMhdMinimalDocumentReference
public struct IheMhdMinimalDocumentReference: Codable, Hashable, Sendable {
    public let author: [MgoReference]?
    public let iheMhdMinimalDocumentReferenceClass: MgoCodeableConcept?
    public let content: Content
    public let context: Context
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let indexed: PrimitiveValueTypeOfInstantInstantDateTimeString?
    public let masterIdentifier: MgoIdentifier?
    public let profile: IheMhdMinimalDocumentReferenceProfile
    public let referenceID: String
    public let relatesTo: [RelatesTo]?
    public let resourceType: String
    public let securityLabel: [MgoCodeableConcept]?
    public let status: MgoCodeOfEnteredInErrorCurrentSuperseded?
    public let subject: MgoReference?
    public let type: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case author
        case iheMhdMinimalDocumentReferenceClass = "class"
        case content, context, fhirVersion, id, identifier, indexed, masterIdentifier, profile
        case referenceID = "referenceId"
        case relatesTo, resourceType, securityLabel, status, subject, type
    }

    public init(author: [MgoReference]?, iheMhdMinimalDocumentReferenceClass: MgoCodeableConcept?, content: Content, context: Context, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, indexed: PrimitiveValueTypeOfInstantInstantDateTimeString?, masterIdentifier: MgoIdentifier?, profile: IheMhdMinimalDocumentReferenceProfile, referenceID: String, relatesTo: [RelatesTo]?, resourceType: String, securityLabel: [MgoCodeableConcept]?, status: MgoCodeOfEnteredInErrorCurrentSuperseded?, subject: MgoReference?, type: MgoCodeableConcept?) {
        self.author = author
        self.iheMhdMinimalDocumentReferenceClass = iheMhdMinimalDocumentReferenceClass
        self.content = content
        self.context = context
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.indexed = indexed
        self.masterIdentifier = masterIdentifier
        self.profile = profile
        self.referenceID = referenceID
        self.relatesTo = relatesTo
        self.resourceType = resourceType
        self.securityLabel = securityLabel
        self.status = status
        self.subject = subject
        self.type = type
    }
}

// MARK: IheMhdMinimalDocumentReference convenience initializers and mutators

public extension IheMhdMinimalDocumentReference {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IheMhdMinimalDocumentReference.self, from: data)
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
        author: [MgoReference]?? = nil,
        iheMhdMinimalDocumentReferenceClass: MgoCodeableConcept?? = nil,
        content: Content? = nil,
        context: Context? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        indexed: PrimitiveValueTypeOfInstantInstantDateTimeString?? = nil,
        masterIdentifier: MgoIdentifier?? = nil,
        profile: IheMhdMinimalDocumentReferenceProfile? = nil,
        referenceID: String? = nil,
        relatesTo: [RelatesTo]?? = nil,
        resourceType: String? = nil,
        securityLabel: [MgoCodeableConcept]?? = nil,
        status: MgoCodeOfEnteredInErrorCurrentSuperseded?? = nil,
        subject: MgoReference?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> IheMhdMinimalDocumentReference {
        return IheMhdMinimalDocumentReference(
            author: author ?? self.author,
            iheMhdMinimalDocumentReferenceClass: iheMhdMinimalDocumentReferenceClass ?? self.iheMhdMinimalDocumentReferenceClass,
            content: content ?? self.content,
            context: context ?? self.context,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            indexed: indexed ?? self.indexed,
            masterIdentifier: masterIdentifier ?? self.masterIdentifier,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            relatesTo: relatesTo ?? self.relatesTo,
            resourceType: resourceType ?? self.resourceType,
            securityLabel: securityLabel ?? self.securityLabel,
            status: status ?? self.status,
            subject: subject ?? self.subject,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
