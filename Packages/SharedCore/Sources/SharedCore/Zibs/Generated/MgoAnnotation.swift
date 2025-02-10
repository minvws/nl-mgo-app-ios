// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoAnnotation = try MgoAnnotation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoAnnotation
public struct MgoAnnotation: Codable, Hashable, Sendable {
    public let author: MgoReference?
    public let text, time: String?

    public init(author: MgoReference?, text: String?, time: String?) {
        self.author = author
        self.text = text
        self.time = time
    }
}

// MARK: MgoAnnotation convenience initializers and mutators

public extension MgoAnnotation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoAnnotation.self, from: data)
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
        author: MgoReference?? = nil,
        text: String?? = nil,
        time: String?? = nil
    ) -> MgoAnnotation {
        return MgoAnnotation(
            author: author ?? self.author,
            text: text ?? self.text,
            time: time ?? self.time
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
