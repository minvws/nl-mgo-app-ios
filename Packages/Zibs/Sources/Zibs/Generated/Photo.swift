// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let photo = try Photo(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Photo
public struct Photo: Codable, Hashable, Sendable {
    public let contentType, creation, data, hash: String?
    public let language: String?
    public let size: Double?
    public let title, url: String?

    public init(contentType: String?, creation: String?, data: String?, hash: String?, language: String?, size: Double?, title: String?, url: String?) {
        self.contentType = contentType
        self.creation = creation
        self.data = data
        self.hash = hash
        self.language = language
        self.size = size
        self.title = title
        self.url = url
    }
}

// MARK: Photo convenience initializers and mutators

public extension Photo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photo.self, from: data)
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
        contentType: String?? = nil,
        creation: String?? = nil,
        data: String?? = nil,
        hash: String?? = nil,
        language: String?? = nil,
        size: Double?? = nil,
        title: String?? = nil,
        url: String?? = nil
    ) -> Photo {
        return Photo(
            contentType: contentType ?? self.contentType,
            creation: creation ?? self.creation,
            data: data ?? self.data,
            hash: hash ?? self.hash,
            language: language ?? self.language,
            size: size ?? self.size,
            title: title ?? self.title,
            url: url ?? self.url
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
