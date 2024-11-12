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
    public let content: IheMhdMinimalDocumentReferenceContent
    public let description, id, indexed: String?
    public let profile: IheMhdMinimalDocumentReferenceProfile
    public let referenceID: String
    public let resourceType: String?
    public let securityLabel: [[MgoCoding]]?
    public let status: String?
    public let type: [MgoCoding]?

    public enum CodingKeys: String, CodingKey {
        case author, content, description, id, indexed, profile
        case referenceID = "referenceId"
        case resourceType, securityLabel, status, type
    }

    public init(author: [MgoReference]?, content: IheMhdMinimalDocumentReferenceContent, description: String?, id: String?, indexed: String?, profile: IheMhdMinimalDocumentReferenceProfile, referenceID: String, resourceType: String?, securityLabel: [[MgoCoding]]?, status: String?, type: [MgoCoding]?) {
        self.author = author
        self.content = content
        self.description = description
        self.id = id
        self.indexed = indexed
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.securityLabel = securityLabel
        self.status = status
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
        content: IheMhdMinimalDocumentReferenceContent? = nil,
        description: String?? = nil,
        id: String?? = nil,
        indexed: String?? = nil,
        profile: IheMhdMinimalDocumentReferenceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        securityLabel: [[MgoCoding]]?? = nil,
        status: String?? = nil,
        type: [MgoCoding]?? = nil
    ) -> IheMhdMinimalDocumentReference {
        return IheMhdMinimalDocumentReference(
            author: author ?? self.author,
            content: content ?? self.content,
            description: description ?? self.description,
            id: id ?? self.id,
            indexed: indexed ?? self.indexed,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            securityLabel: securityLabel ?? self.securityLabel,
            status: status ?? self.status,
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
