// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tentacledGiven = try TentacledGiven(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - TentacledGiven
public struct TentacledGiven: Codable, Hashable, Sendable {
    public let birthName, callName, initials: [PrimitiveValueTypeOfStringString]?

    public init(birthName: [PrimitiveValueTypeOfStringString]?, callName: [PrimitiveValueTypeOfStringString]?, initials: [PrimitiveValueTypeOfStringString]?) {
        self.birthName = birthName
        self.callName = callName
        self.initials = initials
    }
}

// MARK: TentacledGiven convenience initializers and mutators

public extension TentacledGiven {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TentacledGiven.self, from: data)
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
        birthName: [PrimitiveValueTypeOfStringString]?? = nil,
        callName: [PrimitiveValueTypeOfStringString]?? = nil,
        initials: [PrimitiveValueTypeOfStringString]?? = nil
    ) -> TentacledGiven {
        return TentacledGiven(
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
