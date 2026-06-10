// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eAfspraakAppointmentStatus = try EAfspraakAppointmentStatus(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - EAfspraakAppointmentStatus
public struct EAfspraakAppointmentStatus: Codable, Hashable, Sendable {
    public let type: MgoCodeOfStringType?
    public let orderStatus: ExtensionValueOfMgoCodeableConcept?
    public let value: String?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case orderStatus, value
    }

    public init(type: MgoCodeOfStringType?, orderStatus: ExtensionValueOfMgoCodeableConcept?, value: String?) {
        self.type = type
        self.orderStatus = orderStatus
        self.value = value
    }
}

// MARK: EAfspraakAppointmentStatus convenience initializers and mutators

public extension EAfspraakAppointmentStatus {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EAfspraakAppointmentStatus.self, from: data)
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
        type: MgoCodeOfStringType?? = nil,
        orderStatus: ExtensionValueOfMgoCodeableConcept?? = nil,
        value: String?? = nil
    ) -> EAfspraakAppointmentStatus {
        return EAfspraakAppointmentStatus(
            type: type ?? self.type,
            orderStatus: orderStatus ?? self.orderStatus,
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
