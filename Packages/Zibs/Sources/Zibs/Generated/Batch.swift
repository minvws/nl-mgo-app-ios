// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let batch = try Batch(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Batch
public struct Batch: Codable, Hashable, Sendable {
    public let expirationDate, lotNumber: String?

    public init(expirationDate: String?, lotNumber: String?) {
        self.expirationDate = expirationDate
        self.lotNumber = lotNumber
    }
}

// MARK: Batch convenience initializers and mutators

public extension Batch {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Batch.self, from: data)
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
        expirationDate: String?? = nil,
        lotNumber: String?? = nil
    ) -> Batch {
        return Batch(
            expirationDate: expirationDate ?? self.expirationDate,
            lotNumber: lotNumber ?? self.lotNumber
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
