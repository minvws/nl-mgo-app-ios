// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleLine = try PurpleLine(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PurpleLine
public struct PurpleLine: Codable, Hashable, Sendable {
    public let additionalLocator, buildingNumberSuffix, houseNumber, streetName: PrimitiveValueTypeOfStringString?
    public let unitID: PrimitiveValueTypeOfStringString?

    public enum CodingKeys: String, CodingKey {
        case additionalLocator, buildingNumberSuffix, houseNumber, streetName
        case unitID = "unitId"
    }

    public init(additionalLocator: PrimitiveValueTypeOfStringString?, buildingNumberSuffix: PrimitiveValueTypeOfStringString?, houseNumber: PrimitiveValueTypeOfStringString?, streetName: PrimitiveValueTypeOfStringString?, unitID: PrimitiveValueTypeOfStringString?) {
        self.additionalLocator = additionalLocator
        self.buildingNumberSuffix = buildingNumberSuffix
        self.houseNumber = houseNumber
        self.streetName = streetName
        self.unitID = unitID
    }
}

// MARK: PurpleLine convenience initializers and mutators

public extension PurpleLine {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PurpleLine.self, from: data)
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
        additionalLocator: PrimitiveValueTypeOfStringString?? = nil,
        buildingNumberSuffix: PrimitiveValueTypeOfStringString?? = nil,
        houseNumber: PrimitiveValueTypeOfStringString?? = nil,
        streetName: PrimitiveValueTypeOfStringString?? = nil,
        unitID: PrimitiveValueTypeOfStringString?? = nil
    ) -> PurpleLine {
        return PurpleLine(
            additionalLocator: additionalLocator ?? self.additionalLocator,
            buildingNumberSuffix: buildingNumberSuffix ?? self.buildingNumberSuffix,
            houseNumber: houseNumber ?? self.houseNumber,
            streetName: streetName ?? self.streetName,
            unitID: unitID ?? self.unitID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
