// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let payor = try Payor(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Payor
public struct Payor: Codable, Hashable, Sendable {
    public let type: MgoReferenceType?
    public let bankInformation: [ExtensionValueOfStructure0_9777331128362512]
    public let display, reference: String?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case bankInformation, display, reference
    }

    public init(type: MgoReferenceType?, bankInformation: [ExtensionValueOfStructure0_9777331128362512], display: String?, reference: String?) {
        self.type = type
        self.bankInformation = bankInformation
        self.display = display
        self.reference = reference
    }
}

// MARK: Payor convenience initializers and mutators

public extension Payor {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Payor.self, from: data)
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
        type: MgoReferenceType?? = nil,
        bankInformation: [ExtensionValueOfStructure0_9777331128362512]? = nil,
        display: String?? = nil,
        reference: String?? = nil
    ) -> Payor {
        return Payor(
            type: type ?? self.type,
            bankInformation: bankInformation ?? self.bankInformation,
            display: display ?? self.display,
            reference: reference ?? self.reference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
