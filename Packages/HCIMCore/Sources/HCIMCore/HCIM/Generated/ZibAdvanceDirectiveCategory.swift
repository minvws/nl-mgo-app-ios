// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAdvanceDirectiveCategory = try ZibAdvanceDirectiveCategory(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAdvanceDirectiveCategory
public struct ZibAdvanceDirectiveCategory: Codable, Hashable, Sendable {
    public let typeOfLivingWill: [MgoCodeableConcept]?

    public init(typeOfLivingWill: [MgoCodeableConcept]?) {
        self.typeOfLivingWill = typeOfLivingWill
    }
}

// MARK: ZibAdvanceDirectiveCategory convenience initializers and mutators

public extension ZibAdvanceDirectiveCategory {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAdvanceDirectiveCategory.self, from: data)
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
        typeOfLivingWill: [MgoCodeableConcept]?? = nil
    ) -> ZibAdvanceDirectiveCategory {
        return ZibAdvanceDirectiveCategory(
            typeOfLivingWill: typeOfLivingWill ?? self.typeOfLivingWill
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
