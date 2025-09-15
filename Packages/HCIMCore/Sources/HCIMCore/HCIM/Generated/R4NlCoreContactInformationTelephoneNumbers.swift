// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreContactInformationTelephoneNumbers = try R4NlCoreContactInformationTelephoneNumbers(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreContactInformationTelephoneNumbers
public struct R4NlCoreContactInformationTelephoneNumbers: Codable, Hashable, Sendable {
    public let profile: R4NlCoreContactInformationTelephoneNumbersProfile
    public let comment: PrimitiveValueTypeOfStringString?
    public let system: System
    public let use: MgoCode?
    public let value: PrimitiveValueTypeOfStringString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case comment, system, use, value
    }

    public init(profile: R4NlCoreContactInformationTelephoneNumbersProfile, comment: PrimitiveValueTypeOfStringString?, system: System, use: MgoCode?, value: PrimitiveValueTypeOfStringString?) {
        self.profile = profile
        self.comment = comment
        self.system = system
        self.use = use
        self.value = value
    }
}

// MARK: R4NlCoreContactInformationTelephoneNumbers convenience initializers and mutators

public extension R4NlCoreContactInformationTelephoneNumbers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreContactInformationTelephoneNumbers.self, from: data)
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
        profile: R4NlCoreContactInformationTelephoneNumbersProfile? = nil,
        comment: PrimitiveValueTypeOfStringString?? = nil,
        system: System? = nil,
        use: MgoCode?? = nil,
        value: PrimitiveValueTypeOfStringString?? = nil
    ) -> R4NlCoreContactInformationTelephoneNumbers {
        return R4NlCoreContactInformationTelephoneNumbers(
            profile: profile ?? self.profile,
            comment: comment ?? self.comment,
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
