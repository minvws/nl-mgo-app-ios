// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let value = try Value(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Value
public struct Value: Codable, Hashable, Sendable {
    public let display: ChildDisplay?
    public let label: String
    public let summary: Bool?
    public let type: String
    public let reference: String?

    public init(display: ChildDisplay?, label: String, summary: Bool?, type: String, reference: String?) {
        self.display = display
        self.label = label
        self.summary = summary
        self.type = type
        self.reference = reference
    }
}

// MARK: Value convenience initializers and mutators

public extension Value {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Value.self, from: data)
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
        display: ChildDisplay?? = nil,
        label: String? = nil,
        summary: Bool?? = nil,
        type: String? = nil,
        reference: String?? = nil
    ) -> Value {
        return Value(
            display: display ?? self.display,
            label: label ?? self.label,
            summary: summary ?? self.summary,
            type: type ?? self.type,
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
