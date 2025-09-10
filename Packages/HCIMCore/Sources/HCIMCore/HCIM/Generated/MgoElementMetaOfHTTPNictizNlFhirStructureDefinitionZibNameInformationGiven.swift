// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven = try MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven
public struct MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven: Codable, Hashable, Sendable {
    public let profile: R4NlCoreNameInformationGivenProfile

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
    }

    public init(profile: R4NlCoreNameInformationGivenProfile) {
        self.profile = profile
    }
}

// MARK: MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven convenience initializers and mutators

public extension MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven.self, from: data)
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
        profile: R4NlCoreNameInformationGivenProfile? = nil
    ) -> MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven {
        return MgoElementMetaOfHTTPNictizNlFhirStructureDefinitionZibNameInformationGiven(
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
