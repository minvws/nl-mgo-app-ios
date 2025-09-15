// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let primitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction = try PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction
public struct PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction: Codable, Hashable, Sendable {
    public let type: MgoCodeType
    public let value: MgoCodeOfAcceptedDeclinedTentativeNeedsActionValue

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value
    }

    public init(type: MgoCodeType, value: MgoCodeOfAcceptedDeclinedTentativeNeedsActionValue) {
        self.type = type
        self.value = value
    }
}

// MARK: PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction convenience initializers and mutators

public extension PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction.self, from: data)
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
        type: MgoCodeType? = nil,
        value: MgoCodeOfAcceptedDeclinedTentativeNeedsActionValue? = nil
    ) -> PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction {
        return PrimitiveValueTypeOfCodeAcceptedDeclinedTentativeNeedsAction(
            type: type ?? self.type,
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
