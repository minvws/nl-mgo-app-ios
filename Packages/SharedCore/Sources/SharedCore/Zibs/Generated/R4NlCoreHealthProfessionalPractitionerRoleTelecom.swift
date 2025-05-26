// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreHealthProfessionalPractitionerRoleTelecom = try R4NlCoreHealthProfessionalPractitionerRoleTelecom(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreHealthProfessionalPractitionerRoleTelecom
public struct R4NlCoreHealthProfessionalPractitionerRoleTelecom: Codable, Hashable, Sendable {
    public let emailAddresses: [R4NlCoreContactInformationEmailAddresses]
    public let telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]

    public init(emailAddresses: [R4NlCoreContactInformationEmailAddresses], telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]) {
        self.emailAddresses = emailAddresses
        self.telephoneNumbers = telephoneNumbers
    }
}

// MARK: R4NlCoreHealthProfessionalPractitionerRoleTelecom convenience initializers and mutators

public extension R4NlCoreHealthProfessionalPractitionerRoleTelecom {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreHealthProfessionalPractitionerRoleTelecom.self, from: data)
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
        emailAddresses: [R4NlCoreContactInformationEmailAddresses]? = nil,
        telephoneNumbers: [R4NlCoreContactInformationTelephoneNumbers]? = nil
    ) -> R4NlCoreHealthProfessionalPractitionerRoleTelecom {
        return R4NlCoreHealthProfessionalPractitionerRoleTelecom(
            emailAddresses: emailAddresses ?? self.emailAddresses,
            telephoneNumbers: telephoneNumbers ?? self.telephoneNumbers
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
