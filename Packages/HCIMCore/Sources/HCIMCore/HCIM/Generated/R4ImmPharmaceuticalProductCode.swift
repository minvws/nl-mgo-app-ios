// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4ImmPharmaceuticalProductCode = try R4ImmPharmaceuticalProductCode(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4ImmPharmaceuticalProductCode
public struct R4ImmPharmaceuticalProductCode: Codable, Hashable, Sendable {
    public let coding: [MgoCoding]?
    public let text: MgoString?

    public init(coding: [MgoCoding]?, text: MgoString?) {
        self.coding = coding
        self.text = text
    }
}

// MARK: R4ImmPharmaceuticalProductCode convenience initializers and mutators

public extension R4ImmPharmaceuticalProductCode {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4ImmPharmaceuticalProductCode.self, from: data)
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
        coding: [MgoCoding]?? = nil,
        text: MgoString?? = nil
    ) -> R4ImmPharmaceuticalProductCode {
        return R4ImmPharmaceuticalProductCode(
            coding: coding ?? self.coding,
            text: text ?? self.text
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
