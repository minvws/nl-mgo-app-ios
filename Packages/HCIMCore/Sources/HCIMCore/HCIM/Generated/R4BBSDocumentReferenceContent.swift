// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4BBSDocumentReferenceContent = try R4BBSDocumentReferenceContent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4BBSDocumentReferenceContent
public struct R4BBSDocumentReferenceContent: Codable, Hashable, Sendable {
    public let attachment: MgoAttachment?
    public let format: MgoCoding?

    public init(attachment: MgoAttachment?, format: MgoCoding?) {
        self.attachment = attachment
        self.format = format
    }
}

// MARK: R4BBSDocumentReferenceContent convenience initializers and mutators

public extension R4BBSDocumentReferenceContent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4BBSDocumentReferenceContent.self, from: data)
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
        attachment: MgoAttachment?? = nil,
        format: MgoCoding?? = nil
    ) -> R4BBSDocumentReferenceContent {
        return R4BBSDocumentReferenceContent(
            attachment: attachment ?? self.attachment,
            format: format ?? self.format
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
