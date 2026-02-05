// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchResult = try SearchResult(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - SearchResult
public struct SearchResult: Codable, Hashable, Sendable {
    public let document: Organization
    public let id: String
    public let score: Double

    public init(document: Organization, id: String, score: Double) {
        self.document = document
        self.id = id
        self.score = score
    }
}

// MARK: SearchResult convenience initializers and mutators

public extension SearchResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchResult.self, from: data)
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
        document: Organization? = nil,
        id: String? = nil,
        score: Double? = nil
    ) -> SearchResult {
        return SearchResult(
            document: document ?? self.document,
            id: id ?? self.id,
            score: score ?? self.score
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
