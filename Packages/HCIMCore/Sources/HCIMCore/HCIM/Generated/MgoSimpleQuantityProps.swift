// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoSimpleQuantityProps = try MgoSimpleQuantityProps(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoSimpleQuantityProps
public struct MgoSimpleQuantityProps: Codable, Hashable, Sendable {
    public let code, system, unit: String?
    public let value: Double?

    public init(code: String?, system: String?, unit: String?, value: Double?) {
        self.code = code
        self.system = system
        self.unit = unit
        self.value = value
    }
}

// MARK: MgoSimpleQuantityProps convenience initializers and mutators

public extension MgoSimpleQuantityProps {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoSimpleQuantityProps.self, from: data)
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
        code: String?? = nil,
        system: String?? = nil,
        unit: String?? = nil,
        value: Double?? = nil
    ) -> MgoSimpleQuantityProps {
        return MgoSimpleQuantityProps(
            code: code ?? self.code,
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
