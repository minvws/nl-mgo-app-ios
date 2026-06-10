// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stickyGiven = try StickyGiven(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - StickyGiven
public struct StickyGiven: Codable, Hashable, Sendable {
    public let birthName, initials: [MgoString]?

    public init(birthName: [MgoString]?, initials: [MgoString]?) {
        self.birthName = birthName
        self.initials = initials
    }
}

// MARK: StickyGiven convenience initializers and mutators

public extension StickyGiven {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StickyGiven.self, from: data)
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
        initials: [MgoString]?? = nil
    ) -> StickyGiven {
        return StickyGiven(
            birthName: birthName ?? self.birthName,
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
