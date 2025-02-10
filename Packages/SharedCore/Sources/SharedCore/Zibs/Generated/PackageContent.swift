// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let packageContent = try PackageContent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PackageContent
public struct PackageContent: Codable, Hashable, Sendable {
    public let item: MgoCodeableConcept?
    public let reference: MgoReference?

    public init(item: MgoCodeableConcept?, reference: MgoReference?) {
        self.item = item
        self.reference = reference
    }
}

// MARK: PackageContent convenience initializers and mutators

public extension PackageContent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PackageContent.self, from: data)
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
        item: MgoCodeableConcept?? = nil,
        reference: MgoReference?? = nil
    ) -> PackageContent {
        return PackageContent(
            item: item ?? self.item,
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
