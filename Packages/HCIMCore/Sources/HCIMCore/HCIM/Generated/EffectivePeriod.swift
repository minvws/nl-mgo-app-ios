// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let effectivePeriod = try EffectivePeriod(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - EffectivePeriod
public struct EffectivePeriod: Codable, Hashable, Sendable {
    public let type: MgoPeriodType
    public let duration: ExtensionValueOfMgoDuration?
    public let end, start: String?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case duration, end, start
    }

    public init(type: MgoPeriodType, duration: ExtensionValueOfMgoDuration?, end: String?, start: String?) {
        self.type = type
        self.duration = duration
        self.end = end
        self.start = start
    }
}

// MARK: EffectivePeriod convenience initializers and mutators

public extension EffectivePeriod {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EffectivePeriod.self, from: data)
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
        type: MgoPeriodType? = nil,
        duration: ExtensionValueOfMgoDuration?? = nil,
        end: String?? = nil,
        start: String?? = nil
    ) -> EffectivePeriod {
        return EffectivePeriod(
            type: type ?? self.type,
            duration: duration ?? self.duration,
            end: end ?? self.end,
            start: start ?? self.start
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
