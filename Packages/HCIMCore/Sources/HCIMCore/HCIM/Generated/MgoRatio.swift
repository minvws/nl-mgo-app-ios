// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoRatio = try MgoRatio(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoRatio
public struct MgoRatio: Codable, Hashable, Sendable {
    public let type: MgoRatioType
    public let denominator, numerator: MgoQuantityProps?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case denominator, numerator
    }

    public init(type: MgoRatioType, denominator: MgoQuantityProps?, numerator: MgoQuantityProps?) {
        self.type = type
        self.denominator = denominator
        self.numerator = numerator
    }
}

// MARK: MgoRatio convenience initializers and mutators

public extension MgoRatio {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoRatio.self, from: data)
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
        type: MgoRatioType? = nil,
        denominator: MgoQuantityProps?? = nil,
        numerator: MgoQuantityProps?? = nil
    ) -> MgoRatio {
        return MgoRatio(
            type: type ?? self.type,
            denominator: denominator ?? self.denominator,
            numerator: numerator ?? self.numerator
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
