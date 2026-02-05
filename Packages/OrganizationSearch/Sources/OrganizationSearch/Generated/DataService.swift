// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dataService = try DataService(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - DataService
public struct DataService: Codable, Hashable, Sendable {
    public let authEndpoint, resourceEndpoint, tokenEndpoint: String

    public init(authEndpoint: String, resourceEndpoint: String, tokenEndpoint: String) {
        self.authEndpoint = authEndpoint
        self.resourceEndpoint = resourceEndpoint
        self.tokenEndpoint = tokenEndpoint
    }
}

// MARK: DataService convenience initializers and mutators

public extension DataService {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataService.self, from: data)
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
        authEndpoint: String? = nil,
        resourceEndpoint: String? = nil,
        tokenEndpoint: String? = nil
    ) -> DataService {
        return DataService(
            authEndpoint: authEndpoint ?? self.authEndpoint,
            resourceEndpoint: resourceEndpoint ?? self.resourceEndpoint,
            tokenEndpoint: tokenEndpoint ?? self.tokenEndpoint
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
