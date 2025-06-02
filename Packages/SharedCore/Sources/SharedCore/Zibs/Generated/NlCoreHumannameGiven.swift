// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHumannameGiven = try NlCoreHumannameGiven(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHumannameGiven
public struct NlCoreHumannameGiven: Codable, Hashable, Sendable {
    public let birthName, callName, initials: [MgoString]?

    public init(birthName: [MgoString]?, callName: [MgoString]?, initials: [MgoString]?) {
        self.birthName = birthName
        self.callName = callName
        self.initials = initials
    }
}

// MARK: NlCoreHumannameGiven convenience initializers and mutators

public extension NlCoreHumannameGiven {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHumannameGiven.self, from: data)
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
        birthName: [MgoString]?? = nil,
        callName: [MgoString]?? = nil,
        initials: [MgoString]?? = nil
    ) -> NlCoreHumannameGiven {
        return NlCoreHumannameGiven(
            birthName: birthName ?? self.birthName,
            callName: callName ?? self.callName,
            initials: initials ?? self.initials
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
