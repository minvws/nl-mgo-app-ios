// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let collection = try Collection(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Collection
public struct Collection: Codable, Hashable, Sendable {
    public let bodySite: BodySite
    public let collected: Effective?
    public let method: [MgoCoding]?
    public let quantity: MgoQuantity?

    public init(bodySite: BodySite, collected: Effective?, method: [MgoCoding]?, quantity: MgoQuantity?) {
        self.bodySite = bodySite
        self.collected = collected
        self.method = method
        self.quantity = quantity
    }
}

// MARK: Collection convenience initializers and mutators

public extension Collection {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Collection.self, from: data)
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
        bodySite: BodySite? = nil,
        collected: Effective?? = nil,
        method: [MgoCoding]?? = nil,
        quantity: MgoQuantity?? = nil
    ) -> Collection {
        return Collection(
            bodySite: bodySite ?? self.bodySite,
            collected: collected ?? self.collected,
            method: method ?? self.method,
            quantity: quantity ?? self.quantity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
