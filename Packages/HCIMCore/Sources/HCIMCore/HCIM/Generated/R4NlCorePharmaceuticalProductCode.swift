// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePharmaceuticalProductCode = try R4NlCorePharmaceuticalProductCode(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePharmaceuticalProductCode
public struct R4NlCorePharmaceuticalProductCode: Codable, Hashable, Sendable {
    public let coding: [MgoCoding]?
    public let text: MgoString?

    public init(coding: [MgoCoding]?, text: MgoString?) {
        self.coding = coding
        self.text = text
    }
}

// MARK: R4NlCorePharmaceuticalProductCode convenience initializers and mutators

public extension R4NlCorePharmaceuticalProductCode {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePharmaceuticalProductCode.self, from: data)
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
    ) -> R4NlCorePharmaceuticalProductCode {
        return R4NlCorePharmaceuticalProductCode(
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
