// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoIdentifier = try MgoIdentifier(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoIdentifier
public struct MgoIdentifier: Codable, Hashable, Sendable {
    public let system: String?
    public let type: MgoCodeableConcept?
    public let use, value: String?

    public init(system: String?, type: MgoCodeableConcept?, use: String?, value: String?) {
        self.system = system
        self.type = type
        self.use = use
        self.value = value
    }
}

// MARK: MgoIdentifier convenience initializers and mutators

public extension MgoIdentifier {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoIdentifier.self, from: data)
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
        system: String?? = nil,
        type: MgoCodeableConcept?? = nil,
        use: String?? = nil,
        value: String?? = nil
    ) -> MgoIdentifier {
        return MgoIdentifier(
            system: system ?? self.system,
            type: type ?? self.type,
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
