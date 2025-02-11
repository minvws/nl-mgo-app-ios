// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let source = try Source(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Source
public struct Source: Codable, Hashable, Sendable {
    public let attachment: Attachment
    public let identifier: MgoIdentifier?
    public let reference: MgoReference?

    public init(attachment: Attachment, identifier: MgoIdentifier?, reference: MgoReference?) {
        self.attachment = attachment
        self.identifier = identifier
        self.reference = reference
    }
}

// MARK: Source convenience initializers and mutators

public extension Source {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Source.self, from: data)
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
        attachment: Attachment? = nil,
        identifier: MgoIdentifier?? = nil,
        reference: MgoReference?? = nil
    ) -> Source {
        return Source(
            attachment: attachment ?? self.attachment,
            identifier: identifier ?? self.identifier,
            reference: reference ?? self.reference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
