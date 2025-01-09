// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePharmaceuticalProduct = try R4NlCorePharmaceuticalProduct(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePharmaceuticalProduct
public struct R4NlCorePharmaceuticalProduct: Codable, Hashable, Sendable {
    public let amount: MgoRatio?
    public let batch: Batch
    public let code: MgoCodeableConcept?
    public let description: String?
    public let fhirVersion: FhirVersionR4
    public let form: MgoCodeableConcept?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let ingredient: [Ingredient]?
    public let manufacturer: MgoReference?
    public let name: String?
    public let profile: R4NlCorePharmaceuticalProductProfile
    public let referenceID: String
    public let resourceType: String?
    public let status: R4NlCorePharmaceuticalProductStatus?

    public enum CodingKeys: String, CodingKey {
        case amount, batch, code, description, fhirVersion, form, id, identifier, ingredient, manufacturer, name, profile
        case referenceID = "referenceId"
        case resourceType, status
    }

    public init(amount: MgoRatio?, batch: Batch, code: MgoCodeableConcept?, description: String?, fhirVersion: FhirVersionR4, form: MgoCodeableConcept?, id: String?, identifier: [MgoIdentifier]?, ingredient: [Ingredient]?, manufacturer: MgoReference?, name: String?, profile: R4NlCorePharmaceuticalProductProfile, referenceID: String, resourceType: String?, status: R4NlCorePharmaceuticalProductStatus?) {
        self.amount = amount
        self.batch = batch
        self.code = code
        self.description = description
        self.fhirVersion = fhirVersion
        self.form = form
        self.id = id
        self.identifier = identifier
        self.ingredient = ingredient
        self.manufacturer = manufacturer
        self.name = name
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
    }
}

// MARK: R4NlCorePharmaceuticalProduct convenience initializers and mutators

public extension R4NlCorePharmaceuticalProduct {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePharmaceuticalProduct.self, from: data)
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
        amount: MgoRatio?? = nil,
        batch: Batch? = nil,
        code: MgoCodeableConcept?? = nil,
        description: String?? = nil,
        fhirVersion: FhirVersionR4? = nil,
        form: MgoCodeableConcept?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        ingredient: [Ingredient]?? = nil,
        manufacturer: MgoReference?? = nil,
        name: String?? = nil,
        profile: R4NlCorePharmaceuticalProductProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: R4NlCorePharmaceuticalProductStatus?? = nil
    ) -> R4NlCorePharmaceuticalProduct {
        return R4NlCorePharmaceuticalProduct(
            amount: amount ?? self.amount,
            batch: batch ?? self.batch,
            code: code ?? self.code,
            description: description ?? self.description,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            form: form ?? self.form,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            ingredient: ingredient ?? self.ingredient,
            manufacturer: manufacturer ?? self.manufacturer,
            name: name ?? self.name,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
