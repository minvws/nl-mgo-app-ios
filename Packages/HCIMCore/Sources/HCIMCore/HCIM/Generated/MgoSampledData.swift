// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoSampledData = try MgoSampledData(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoSampledData
public struct MgoSampledData: Codable, Hashable, Sendable {
    public let type: MgoSampledDataType
    public let data: PrimitiveValueTypeOfStringString?
    public let dimensions: MgoPositiveInt?
    public let factor, lowerLimit: PrimitiveValueTypeOfDecimalNumber?
    public let origin: MgoSimpleQuantity?
    public let period: PrimitiveValueTypeOfDecimalNumber
    public let upperLimit: PrimitiveValueTypeOfDecimalNumber?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case data, dimensions, factor, lowerLimit, origin, period, upperLimit
    }

    public init(type: MgoSampledDataType, data: PrimitiveValueTypeOfStringString?, dimensions: MgoPositiveInt?, factor: PrimitiveValueTypeOfDecimalNumber?, lowerLimit: PrimitiveValueTypeOfDecimalNumber?, origin: MgoSimpleQuantity?, period: PrimitiveValueTypeOfDecimalNumber, upperLimit: PrimitiveValueTypeOfDecimalNumber?) {
        self.type = type
        self.data = data
        self.dimensions = dimensions
        self.factor = factor
        self.lowerLimit = lowerLimit
        self.origin = origin
        self.period = period
        self.upperLimit = upperLimit
    }
}

// MARK: MgoSampledData convenience initializers and mutators

public extension MgoSampledData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoSampledData.self, from: data)
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
        type: MgoSampledDataType? = nil,
        data: PrimitiveValueTypeOfStringString?? = nil,
        dimensions: MgoPositiveInt?? = nil,
        factor: PrimitiveValueTypeOfDecimalNumber?? = nil,
        lowerLimit: PrimitiveValueTypeOfDecimalNumber?? = nil,
        origin: MgoSimpleQuantity?? = nil,
        period: PrimitiveValueTypeOfDecimalNumber? = nil,
        upperLimit: PrimitiveValueTypeOfDecimalNumber?? = nil
    ) -> MgoSampledData {
        return MgoSampledData(
            type: type ?? self.type,
            data: data ?? self.data,
            dimensions: dimensions ?? self.dimensions,
            factor: factor ?? self.factor,
            lowerLimit: lowerLimit ?? self.lowerLimit,
            origin: origin ?? self.origin,
            period: period ?? self.period,
            upperLimit: upperLimit ?? self.upperLimit
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
