// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibDrugUseComponent = try ZibDrugUseComponent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibDrugUseComponent
public struct ZibDrugUseComponent: Codable, Hashable, Sendable {
    public let amount: [FluffyAmount]?
    public let drugOrMedicationType: [DrugOrMedicationType]?
    public let routeOfAdministration: [RouteOfAdministration]?

    public init(amount: [FluffyAmount]?, drugOrMedicationType: [DrugOrMedicationType]?, routeOfAdministration: [RouteOfAdministration]?) {
        self.amount = amount
        self.drugOrMedicationType = drugOrMedicationType
        self.routeOfAdministration = routeOfAdministration
    }
}

// MARK: ZibDrugUseComponent convenience initializers and mutators

public extension ZibDrugUseComponent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibDrugUseComponent.self, from: data)
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
        amount: [FluffyAmount]?? = nil,
        drugOrMedicationType: [DrugOrMedicationType]?? = nil,
        routeOfAdministration: [RouteOfAdministration]?? = nil
    ) -> ZibDrugUseComponent {
        return ZibDrugUseComponent(
            amount: amount ?? self.amount,
            drugOrMedicationType: drugOrMedicationType ?? self.drugOrMedicationType,
            routeOfAdministration: routeOfAdministration ?? self.routeOfAdministration
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
