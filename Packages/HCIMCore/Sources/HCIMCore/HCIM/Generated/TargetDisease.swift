// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let targetDisease = try TargetDisease(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - TargetDisease
public struct TargetDisease: Codable, Hashable, Sendable {
    public let targetDisease: [MgoCodeableConcept]

    public init(targetDisease: [MgoCodeableConcept]) {
        self.targetDisease = targetDisease
    }
}

// MARK: TargetDisease convenience initializers and mutators

public extension TargetDisease {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TargetDisease.self, from: data)
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
        targetDisease: [MgoCodeableConcept]? = nil
    ) -> TargetDisease {
        return TargetDisease(
            targetDisease: targetDisease ?? self.targetDisease
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
