// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreContactpoint = try NlCoreContactpoint(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreContactpoint
public struct NlCoreContactpoint: Codable, Hashable, Sendable {
    public let period: MgoPeriod?
    public let rank: Double?
    public let system, use, value: String?

    public init(period: MgoPeriod?, rank: Double?, system: String?, use: String?, value: String?) {
        self.period = period
        self.rank = rank
        self.system = system
        self.use = use
        self.value = value
    }
}

// MARK: NlCoreContactpoint convenience initializers and mutators

public extension NlCoreContactpoint {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreContactpoint.self, from: data)
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
        period: MgoPeriod?? = nil,
        rank: Double?? = nil,
        system: String?? = nil,
        use: String?? = nil,
        value: String?? = nil
    ) -> NlCoreContactpoint {
        return NlCoreContactpoint(
            period: period ?? self.period,
            rank: rank ?? self.rank,
            system: system ?? self.system,
            use: use ?? self.use,
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
