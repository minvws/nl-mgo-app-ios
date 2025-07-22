// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let oralDiet = try OralDiet(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - OralDiet
public struct OralDiet: Codable, Hashable, Sendable {
    public let fluidConsistencyType: [MgoCodeableConcept]?
    public let texture: [Texture]?
    public let type: [MgoCodeableConcept]?

    public init(fluidConsistencyType: [MgoCodeableConcept]?, texture: [Texture]?, type: [MgoCodeableConcept]?) {
        self.fluidConsistencyType = fluidConsistencyType
        self.texture = texture
        self.type = type
    }
}

// MARK: OralDiet convenience initializers and mutators

public extension OralDiet {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OralDiet.self, from: data)
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
        fluidConsistencyType: [MgoCodeableConcept]?? = nil,
        texture: [Texture]?? = nil,
        type: [MgoCodeableConcept]?? = nil
    ) -> OralDiet {
        return OralDiet(
            fluidConsistencyType: fluidConsistencyType ?? self.fluidConsistencyType,
            texture: texture ?? self.texture,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
