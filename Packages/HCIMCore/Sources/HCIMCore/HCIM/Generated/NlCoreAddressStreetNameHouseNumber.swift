// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreAddressStreetNameHouseNumber = try NlCoreAddressStreetNameHouseNumber(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreAddressStreetNameHouseNumber
public struct NlCoreAddressStreetNameHouseNumber: Codable, Hashable, Sendable {
    public let additionalLocator, buildingNumbersuffix, houseNumber, streetName: PrimitiveValueTypeOfStringString?
    public let unitID: PrimitiveValueTypeOfStringString?

    public init(additionalLocator: PrimitiveValueTypeOfStringString?, buildingNumbersuffix: PrimitiveValueTypeOfStringString?, houseNumber: PrimitiveValueTypeOfStringString?, streetName: PrimitiveValueTypeOfStringString?, unitID: PrimitiveValueTypeOfStringString?) {
        self.additionalLocator = additionalLocator
        self.buildingNumbersuffix = buildingNumbersuffix
        self.houseNumber = houseNumber
        self.streetName = streetName
        self.unitID = unitID
    }
}

// MARK: NlCoreAddressStreetNameHouseNumber convenience initializers and mutators

public extension NlCoreAddressStreetNameHouseNumber {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreAddressStreetNameHouseNumber.self, from: data)
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
        buildingNumbersuffix: PrimitiveValueTypeOfStringString?? = nil,
        houseNumber: PrimitiveValueTypeOfStringString?? = nil,
        streetName: PrimitiveValueTypeOfStringString?? = nil,
        unitID: PrimitiveValueTypeOfStringString?? = nil
    ) -> NlCoreAddressStreetNameHouseNumber {
        return NlCoreAddressStreetNameHouseNumber(
            additionalLocator: additionalLocator ?? self.additionalLocator,
            buildingNumbersuffix: buildingNumbersuffix ?? self.buildingNumbersuffix,
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
