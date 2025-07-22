// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stickyType = try StickyType(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - StickyType
public struct StickyType: Codable, Hashable, Sendable {
    public let healthProfessionalRole: [MgoCodeableConcept]?

    public init(healthProfessionalRole: [MgoCodeableConcept]?) {
        self.healthProfessionalRole = healthProfessionalRole
    }
}

// MARK: StickyType convenience initializers and mutators

public extension StickyType {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StickyType.self, from: data)
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
        healthProfessionalRole: [MgoCodeableConcept]?? = nil
    ) -> StickyType {
        return StickyType(
            healthProfessionalRole: healthProfessionalRole ?? self.healthProfessionalRole
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
