// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreOrganizationTelecom = try NlCoreOrganizationTelecom(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreOrganizationTelecom
public struct NlCoreOrganizationTelecom: Codable, Hashable, Sendable {
    public let profile: NlCoreContactpointProfile
    public let system: NlCoreOrganizationTelecomSystem?
    public let telecomType: MgoCodeableConcept?
    public let use: NlCoreOrganizationTelecomSystem?
    public let value: MgoString?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case system, telecomType, use, value
    }

    public init(profile: NlCoreContactpointProfile, system: NlCoreOrganizationTelecomSystem?, telecomType: MgoCodeableConcept?, use: NlCoreOrganizationTelecomSystem?, value: MgoString?) {
        self.profile = profile
        self.system = system
        self.telecomType = telecomType
        self.use = use
        self.value = value
    }
}

// MARK: NlCoreOrganizationTelecom convenience initializers and mutators

public extension NlCoreOrganizationTelecom {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreOrganizationTelecom.self, from: data)
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
        system: NlCoreOrganizationTelecomSystem?? = nil,
        telecomType: MgoCodeableConcept?? = nil,
        use: NlCoreOrganizationTelecomSystem?? = nil,
        value: MgoString?? = nil
    ) -> NlCoreOrganizationTelecom {
        return NlCoreOrganizationTelecom(
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
