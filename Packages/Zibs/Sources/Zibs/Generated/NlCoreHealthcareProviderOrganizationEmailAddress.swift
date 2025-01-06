// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHealthcareProviderOrganizationEmailAddress = try NlCoreHealthcareProviderOrganizationEmailAddress(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHealthcareProviderOrganizationEmailAddress
public struct NlCoreHealthcareProviderOrganizationEmailAddress: Codable, Hashable, Sendable {
    public let system: EmailAddressSystem
    public let use, value: String?

    public init(system: EmailAddressSystem, use: String?, value: String?) {
        self.system = system
        self.use = use
        self.value = value
    }
}

// MARK: NlCoreHealthcareProviderOrganizationEmailAddress convenience initializers and mutators

public extension NlCoreHealthcareProviderOrganizationEmailAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHealthcareProviderOrganizationEmailAddress.self, from: data)
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
        system: EmailAddressSystem? = nil,
        use: String?? = nil,
        value: String?? = nil
    ) -> NlCoreHealthcareProviderOrganizationEmailAddress {
        return NlCoreHealthcareProviderOrganizationEmailAddress(
            system: system ?? self.system,
            use: use ?? self.use,
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
