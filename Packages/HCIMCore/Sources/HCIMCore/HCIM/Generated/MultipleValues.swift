// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let multipleValues = try MultipleValues(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MultipleValues
public struct MultipleValues: Codable, Hashable, Sendable {
    public let display: [String]?
    public let label: String
    public let type: MultipleValuesType

    public init(display: [String]?, label: String, type: MultipleValuesType) {
        self.display = display
        self.label = label
        self.type = type
    }
}

// MARK: MultipleValues convenience initializers and mutators

public extension MultipleValues {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MultipleValues.self, from: data)
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
        display: [String]?? = nil,
        label: String? = nil,
        type: MultipleValuesType? = nil
    ) -> MultipleValues {
        return MultipleValues(
            display: display ?? self.display,
            label: label ?? self.label,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
