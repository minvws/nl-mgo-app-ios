// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress = try MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress
public struct MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress: Codable, Hashable, Sendable {
    public let profile: NlCoreAddressProfile

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
    }

    public init(profile: NlCoreAddressProfile) {
        self.profile = profile
    }
}

// MARK: MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress convenience initializers and mutators

public extension MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress.self, from: data)
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
        profile: NlCoreAddressProfile? = nil
    ) -> MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress {
        return MgoElementMetaOfHTTPFhirNlFhirStructureDefinitionNlCoreAddress(
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
