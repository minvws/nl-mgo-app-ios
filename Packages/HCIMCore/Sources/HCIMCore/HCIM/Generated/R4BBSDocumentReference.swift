// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4BBSDocumentReference = try R4BBSDocumentReference(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4BBSDocumentReference
public struct R4BBSDocumentReference: Codable, Hashable, Sendable {
    public let author: [MgoReference]?
    public let content: [R4BBSDocumentReferenceContent]?
    public let context: R4BBSDocumentReferenceContext
    public let date: MgoDateTime?
    public let fhirVersion: R4BBSDocumentReferenceFhirVersion
    public let id: String?
    public let masterIdentifier: MgoIdentifier?
    public let profile: R4BBSDocumentReferenceProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?
    public let type: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case author, content, context, date, fhirVersion, id, masterIdentifier, profile
        case referenceID = "referenceId"
        case resourceType, subject, type
    }

    public init(author: [MgoReference]?, content: [R4BBSDocumentReferenceContent]?, context: R4BBSDocumentReferenceContext, date: MgoDateTime?, fhirVersion: R4BBSDocumentReferenceFhirVersion, id: String?, masterIdentifier: MgoIdentifier?, profile: R4BBSDocumentReferenceProfile, referenceID: String, resourceType: String, subject: MgoReference?, type: MgoCodeableConcept?) {
        self.author = author
        self.content = content
        self.context = context
        self.date = date
        self.fhirVersion = fhirVersion
        self.id = id
        self.masterIdentifier = masterIdentifier
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.type = type
    }
}

// MARK: R4BBSDocumentReference convenience initializers and mutators

public extension R4BBSDocumentReference {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4BBSDocumentReference.self, from: data)
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
        content: [R4BBSDocumentReferenceContent]?? = nil,
        context: R4BBSDocumentReferenceContext? = nil,
        date: MgoDateTime?? = nil,
        fhirVersion: R4BBSDocumentReferenceFhirVersion? = nil,
        id: String?? = nil,
        masterIdentifier: MgoIdentifier?? = nil,
        profile: R4BBSDocumentReferenceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> R4BBSDocumentReference {
        return R4BBSDocumentReference(
            author: author ?? self.author,
            content: content ?? self.content,
            context: context ?? self.context,
            date: date ?? self.date,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            masterIdentifier: masterIdentifier ?? self.masterIdentifier,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
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
