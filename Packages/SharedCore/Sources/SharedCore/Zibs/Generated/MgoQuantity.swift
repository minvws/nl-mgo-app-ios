// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoQuantity = try MgoQuantity(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoQuantity
public struct MgoQuantity: Codable, Hashable, Sendable {
    public let type: MgoQuantityType
    public let code, comparator, system, unit: String?
    public let value: Double?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case code, comparator, system, unit, value
    }

    public init(type: MgoQuantityType, code: String?, comparator: String?, system: String?, unit: String?, value: Double?) {
        self.type = type
        self.code = code
        self.comparator = comparator
        self.system = system
        self.unit = unit
        self.value = value
    }
}

// MARK: MgoQuantity convenience initializers and mutators

public extension MgoQuantity {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoQuantity.self, from: data)
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
        type: MgoQuantityType? = nil,
        code: String?? = nil,
        comparator: String?? = nil,
        system: String?? = nil,
        unit: String?? = nil,
        value: Double?? = nil
    ) -> MgoQuantity {
        return MgoQuantity(
            type: type ?? self.type,
            code: code ?? self.code,
            comparator: comparator ?? self.comparator,
            system: system ?? self.system,
            unit: unit ?? self.unit,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
