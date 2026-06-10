// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreContactpoint = try NlCoreContactpoint(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreContactpoint
public struct NlCoreContactpoint: Codable, Hashable, Sendable {
    public let profile: NlCoreContactpointProfile
    public let system: MgoCodeOfString?
    public let telecomType: MgoCodeableConcept?
    public let use: MgoCodeOfString?
    public let value: MgoString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case system, telecomType, use, value
    }

    public init(profile: NlCoreContactpointProfile, system: MgoCodeOfString?, telecomType: MgoCodeableConcept?, use: MgoCodeOfString?, value: MgoString?) {
        self.profile = profile
        self.system = system
        self.telecomType = telecomType
        self.use = use
        self.value = value
    }
}

// MARK: NlCoreContactpoint convenience initializers and mutators

public extension NlCoreContactpoint {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreContactpoint.self, from: data)
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
        profile: NlCoreContactpointProfile? = nil,
        system: MgoCodeOfString?? = nil,
        telecomType: MgoCodeableConcept?? = nil,
        use: MgoCodeOfString?? = nil,
        value: MgoString?? = nil
    ) -> NlCoreContactpoint {
        return NlCoreContactpoint(
            profile: profile ?? self.profile,
            system: system ?? self.system,
            telecomType: telecomType ?? self.telecomType,
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
