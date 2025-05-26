// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthcareProviderOrganizationType = try R4NlCoreHealthcareProviderOrganizationType(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthcareProviderOrganizationType
public struct R4NlCoreHealthcareProviderOrganizationType: Codable, Hashable, Sendable {
    public let departmentSpecialty, organizationType: [MgoCodeableConcept]?

    public init(departmentSpecialty: [MgoCodeableConcept]?, organizationType: [MgoCodeableConcept]?) {
        self.departmentSpecialty = departmentSpecialty
        self.organizationType = organizationType
    }
}

// MARK: R4NlCoreHealthcareProviderOrganizationType convenience initializers and mutators

public extension R4NlCoreHealthcareProviderOrganizationType {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthcareProviderOrganizationType.self, from: data)
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
        departmentSpecialty: [MgoCodeableConcept]?? = nil,
        organizationType: [MgoCodeableConcept]?? = nil
    ) -> R4NlCoreHealthcareProviderOrganizationType {
        return R4NlCoreHealthcareProviderOrganizationType(
            departmentSpecialty: departmentSpecialty ?? self.departmentSpecialty,
            organizationType: organizationType ?? self.organizationType
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
