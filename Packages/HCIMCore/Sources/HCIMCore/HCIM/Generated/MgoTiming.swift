// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoTiming = try MgoTiming(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoTiming
public struct MgoTiming: Codable, Hashable, Sendable {
    public let type: MgoTimingType
    public let code: MgoCodeableConcept?
    public let event: [PrimitiveValueTypeOfDateTimeDateTimeString]?
    public let mgoTimingRepeat: MgoTimingRepeat

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case code, event
        case mgoTimingRepeat = "repeat"
    }

    public init(type: MgoTimingType, code: MgoCodeableConcept?, event: [PrimitiveValueTypeOfDateTimeDateTimeString]?, mgoTimingRepeat: MgoTimingRepeat) {
        self.type = type
        self.code = code
        self.event = event
        self.mgoTimingRepeat = mgoTimingRepeat
    }
}

// MARK: MgoTiming convenience initializers and mutators

public extension MgoTiming {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoTiming.self, from: data)
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
        type: MgoTimingType? = nil,
        code: MgoCodeableConcept?? = nil,
        event: [PrimitiveValueTypeOfDateTimeDateTimeString]?? = nil,
        mgoTimingRepeat: MgoTimingRepeat? = nil
    ) -> MgoTiming {
        return MgoTiming(
            type: type ?? self.type,
            code: code ?? self.code,
            event: event ?? self.event,
            mgoTimingRepeat: mgoTimingRepeat ?? self.mgoTimingRepeat
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
