// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eAfspraakAppointmentOnlineEditable = try EAfspraakAppointmentOnlineEditable(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - EAfspraakAppointmentOnlineEditable
public struct EAfspraakAppointmentOnlineEditable: Codable, Hashable, Sendable {
    public let ext: Bool
    public let indicator: ExtensionValueOfMgoBoolean?
    public let onlineEditableUntil: ExtensionValueOfMgoDateTime?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case indicator, onlineEditableUntil
    }

    public init(ext: Bool, indicator: ExtensionValueOfMgoBoolean?, onlineEditableUntil: ExtensionValueOfMgoDateTime?) {
        self.ext = ext
        self.indicator = indicator
        self.onlineEditableUntil = onlineEditableUntil
    }
}

// MARK: EAfspraakAppointmentOnlineEditable convenience initializers and mutators

public extension EAfspraakAppointmentOnlineEditable {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EAfspraakAppointmentOnlineEditable.self, from: data)
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
        ext: Bool? = nil,
        indicator: ExtensionValueOfMgoBoolean?? = nil,
        onlineEditableUntil: ExtensionValueOfMgoDateTime?? = nil
    ) -> EAfspraakAppointmentOnlineEditable {
        return EAfspraakAppointmentOnlineEditable(
            ext: ext ?? self.ext,
            indicator: indicator ?? self.indicator,
            onlineEditableUntil: onlineEditableUntil ?? self.onlineEditableUntil
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
