// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHumanname = try NlCoreHumanname(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHumanname
public struct NlCoreHumanname: Codable, Hashable, Sendable {
    public let profile: NlCoreHumannameProfile
    public let family: NlCoreHumannameFamily
    public let given: NlCoreHumannameGiven
    public let humannameAssemblyOrder: MgoCode?
    public let text: MgoString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case family, given, humannameAssemblyOrder, text
    }

    public init(profile: NlCoreHumannameProfile, family: NlCoreHumannameFamily, given: NlCoreHumannameGiven, humannameAssemblyOrder: MgoCode?, text: MgoString?) {
        self.profile = profile
        self.family = family
        self.given = given
        self.humannameAssemblyOrder = humannameAssemblyOrder
        self.text = text
    }
}

// MARK: NlCoreHumanname convenience initializers and mutators

public extension NlCoreHumanname {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHumanname.self, from: data)
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
        family: NlCoreHumannameFamily? = nil,
        given: NlCoreHumannameGiven? = nil,
        humannameAssemblyOrder: MgoCode?? = nil,
        text: MgoString?? = nil
    ) -> NlCoreHumanname {
        return NlCoreHumanname(
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
