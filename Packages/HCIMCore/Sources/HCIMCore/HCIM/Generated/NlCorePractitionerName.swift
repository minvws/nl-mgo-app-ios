// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCorePractitionerName = try NlCorePractitionerName(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCorePractitionerName
public struct NlCorePractitionerName: Codable, Hashable, Sendable {
    public let profile: NlCoreHumannameProfile
    public let family: FluffyFamily
    public let given: FluffyGiven
    public let humannameAssemblyOrder: MgoCodeOfString?
    public let text: PrimitiveValueTypeOfStringString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case family, given, humannameAssemblyOrder, text
    }

    public init(profile: NlCoreHumannameProfile, family: FluffyFamily, given: FluffyGiven, humannameAssemblyOrder: MgoCodeOfString?, text: PrimitiveValueTypeOfStringString?) {
        self.profile = profile
        self.family = family
        self.given = given
        self.humannameAssemblyOrder = humannameAssemblyOrder
        self.text = text
    }
}

// MARK: NlCorePractitionerName convenience initializers and mutators

public extension NlCorePractitionerName {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCorePractitionerName.self, from: data)
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
        profile: NlCoreHumannameProfile? = nil,
        family: FluffyFamily? = nil,
        given: FluffyGiven? = nil,
        humannameAssemblyOrder: MgoCodeOfString?? = nil,
        text: PrimitiveValueTypeOfStringString?? = nil
    ) -> NlCorePractitionerName {
        return NlCorePractitionerName(
            profile: profile ?? self.profile,
            family: family ?? self.family,
            given: given ?? self.given,
            humannameAssemblyOrder: humannameAssemblyOrder ?? self.humannameAssemblyOrder,
            text: text ?? self.text
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
