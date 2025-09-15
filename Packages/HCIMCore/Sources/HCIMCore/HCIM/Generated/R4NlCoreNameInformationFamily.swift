// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCoreNameInformationFamily = try R4NlCoreNameInformationFamily(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCoreNameInformationFamily
public struct R4NlCoreNameInformationFamily: Codable, Hashable, Sendable {
    public let humannameOwnName, humannameOwnPrefix, humannamePartnerName, humannamePartnerPrefix: PrimitiveValueTypeOfStringString?

    public init(humannameOwnName: PrimitiveValueTypeOfStringString?, humannameOwnPrefix: PrimitiveValueTypeOfStringString?, humannamePartnerName: PrimitiveValueTypeOfStringString?, humannamePartnerPrefix: PrimitiveValueTypeOfStringString?) {
        self.humannameOwnName = humannameOwnName
        self.humannameOwnPrefix = humannameOwnPrefix
        self.humannamePartnerName = humannamePartnerName
        self.humannamePartnerPrefix = humannamePartnerPrefix
    }
}

// MARK: R4NlCoreNameInformationFamily convenience initializers and mutators

public extension R4NlCoreNameInformationFamily {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCoreNameInformationFamily.self, from: data)
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
        humannameOwnName: PrimitiveValueTypeOfStringString?? = nil,
        humannameOwnPrefix: PrimitiveValueTypeOfStringString?? = nil,
        humannamePartnerName: PrimitiveValueTypeOfStringString?? = nil,
        humannamePartnerPrefix: PrimitiveValueTypeOfStringString?? = nil
    ) -> R4NlCoreNameInformationFamily {
        return R4NlCoreNameInformationFamily(
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
