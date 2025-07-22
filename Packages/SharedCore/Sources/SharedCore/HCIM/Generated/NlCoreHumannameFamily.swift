// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHumannameFamily = try NlCoreHumannameFamily(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHumannameFamily
public struct NlCoreHumannameFamily: Codable, Hashable, Sendable {
    public let humannameOwnName, humannameOwnPrefix, humannamePartnerName, humannamePartnerPrefix: MgoString?

    public init(humannameOwnName: MgoString?, humannameOwnPrefix: MgoString?, humannamePartnerName: MgoString?, humannamePartnerPrefix: MgoString?) {
        self.humannameOwnName = humannameOwnName
        self.humannameOwnPrefix = humannameOwnPrefix
        self.humannamePartnerName = humannamePartnerName
        self.humannamePartnerPrefix = humannamePartnerPrefix
    }
}

// MARK: NlCoreHumannameFamily convenience initializers and mutators

public extension NlCoreHumannameFamily {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHumannameFamily.self, from: data)
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
        humannameOwnName: MgoString?? = nil,
        humannameOwnPrefix: MgoString?? = nil,
        humannamePartnerName: MgoString?? = nil,
        humannamePartnerPrefix: MgoString?? = nil
    ) -> NlCoreHumannameFamily {
        return NlCoreHumannameFamily(
            humannameOwnName: humannameOwnName ?? self.humannameOwnName,
            humannameOwnPrefix: humannameOwnPrefix ?? self.humannameOwnPrefix,
            humannamePartnerName: humannamePartnerName ?? self.humannamePartnerName,
            humannamePartnerPrefix: humannamePartnerPrefix ?? self.humannamePartnerPrefix
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
