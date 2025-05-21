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
    public let content: IheMhdMinimalDocumentReferenceContent
    public let fhirVersion: FhirVersionR3
    public let id, indexed: String?
    public let masterIdentifier: MgoIdentifier?
    public let profile: IheMhdMinimalDocumentReferenceProfile
    public let referenceID: String
    public let resourceType: String?
    public let securityLabel: [MgoCodeableConcept]?
    public let status: IheMhdMinimalDocumentReferenceStatus?
    public let subject: MgoReference?
    public let type: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case author
        case iheMhdMinimalDocumentReferenceClass = "class"
        case content, fhirVersion, id, indexed, masterIdentifier, profile
        case referenceID = "referenceId"
        case resourceType, securityLabel, status, subject, type
    }

    public init(author: [MgoReference]?, iheMhdMinimalDocumentReferenceClass: MgoCodeableConcept?, content: IheMhdMinimalDocumentReferenceContent, fhirVersion: FhirVersionR3, id: String?, indexed: String?, masterIdentifier: MgoIdentifier?, profile: IheMhdMinimalDocumentReferenceProfile, referenceID: String, resourceType: String?, securityLabel: [MgoCodeableConcept]?, status: IheMhdMinimalDocumentReferenceStatus?, subject: MgoReference?, type: MgoCodeableConcept?) {
        self.author = author
        self.iheMhdMinimalDocumentReferenceClass = iheMhdMinimalDocumentReferenceClass
        self.content = content
        self.fhirVersion = fhirVersion
        self.id = id
        self.indexed = indexed
        self.masterIdentifier = masterIdentifier
        self.profile = profile
        self.referenceID = referenceID
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
        content: IheMhdMinimalDocumentReferenceContent? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        indexed: String?? = nil,
        masterIdentifier: MgoIdentifier?? = nil,
        profile: IheMhdMinimalDocumentReferenceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        securityLabel: [MgoCodeableConcept]?? = nil,
        status: IheMhdMinimalDocumentReferenceStatus?? = nil,
        subject: MgoReference?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> IheMhdMinimalDocumentReference {
        return IheMhdMinimalDocumentReference(
            author: author ?? self.author,
            iheMhdMinimalDocumentReferenceClass: iheMhdMinimalDocumentReferenceClass ?? self.iheMhdMinimalDocumentReferenceClass,
            content: content ?? self.content,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            indexed: indexed ?? self.indexed,
            masterIdentifier: masterIdentifier ?? self.masterIdentifier,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
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
