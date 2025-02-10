// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAdministrationSchedule = try ZibAdministrationSchedule(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAdministrationSchedule
public struct ZibAdministrationSchedule: Codable, Hashable, Sendable {
    public let zibAdministrationScheduleRepeat: Repeat

    public enum CodingKeys: String, CodingKey {
        case zibAdministrationScheduleRepeat = "repeat"
    }

    public init(zibAdministrationScheduleRepeat: Repeat) {
        self.zibAdministrationScheduleRepeat = zibAdministrationScheduleRepeat
    }
}

// MARK: ZibAdministrationSchedule convenience initializers and mutators

public extension ZibAdministrationSchedule {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAdministrationSchedule.self, from: data)
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
        zibAdministrationScheduleRepeat: Repeat? = nil
    ) -> ZibAdministrationSchedule {
        return ZibAdministrationSchedule(
            zibAdministrationScheduleRepeat: zibAdministrationScheduleRepeat ?? self.zibAdministrationScheduleRepeat
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
