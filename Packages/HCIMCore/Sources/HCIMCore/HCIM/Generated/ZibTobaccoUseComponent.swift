// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTobaccoUseComponent = try ZibTobaccoUseComponent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTobaccoUseComponent
public struct ZibTobaccoUseComponent: Codable, Hashable, Sendable {
    public let amount: FluffyAmount?
    public let packYears: PackYears?
    public let typeOfTobaccoUsed: TypeOfTobaccoUsed?

    public init(amount: FluffyAmount?, packYears: PackYears?, typeOfTobaccoUsed: TypeOfTobaccoUsed?) {
        self.amount = amount
        self.packYears = packYears
        self.typeOfTobaccoUsed = typeOfTobaccoUsed
    }
}

// MARK: ZibTobaccoUseComponent convenience initializers and mutators

public extension ZibTobaccoUseComponent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTobaccoUseComponent.self, from: data)
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
        amount: FluffyAmount?? = nil,
        packYears: PackYears?? = nil,
        typeOfTobaccoUsed: TypeOfTobaccoUsed?? = nil
    ) -> ZibTobaccoUseComponent {
        return ZibTobaccoUseComponent(
            amount: amount ?? self.amount,
            packYears: packYears ?? self.packYears,
            typeOfTobaccoUsed: typeOfTobaccoUsed ?? self.typeOfTobaccoUsed
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
