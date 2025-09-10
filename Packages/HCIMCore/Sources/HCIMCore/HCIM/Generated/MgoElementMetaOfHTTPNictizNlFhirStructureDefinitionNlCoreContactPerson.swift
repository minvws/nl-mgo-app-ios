// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson = try MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson
public struct MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson: Codable, Hashable, Sendable {
    public let profile: ContactProfile

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
    }

    public init(profile: ContactProfile) {
        self.profile = profile
    }
}

// MARK: MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson convenience initializers and mutators

public extension MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson.self, from: data)
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
        profile: ContactProfile? = nil
    ) -> MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson {
        return MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionNlCoreContactPerson(
            profile: profile ?? self.profile
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
