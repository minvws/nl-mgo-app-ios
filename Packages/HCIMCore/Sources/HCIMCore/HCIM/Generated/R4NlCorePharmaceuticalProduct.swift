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
    public let batch: Batch
    public let code: R4NlCorePharmaceuticalProductCode
    public let fhirVersion: R4NlCoreHealthcareProviderFhirVersion
    public let form: MgoCodeableConcept?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let ingredient: [R4NlCorePharmaceuticalProductIngredient]?
    public let profile: R4NlCorePharmaceuticalProductProfile
    public let referenceID, resourceType: String

    public enum CodingKeys: String, CodingKey {
        case batch, code, fhirVersion, form, id, identifier, ingredient, profile
        case referenceID = "referenceId"
        case resourceType
    }

    public init(batch: Batch, code: R4NlCorePharmaceuticalProductCode, fhirVersion: R4NlCoreHealthcareProviderFhirVersion, form: MgoCodeableConcept?, id: String?, identifier: [MgoIdentifier]?, ingredient: [R4NlCorePharmaceuticalProductIngredient]?, profile: R4NlCorePharmaceuticalProductProfile, referenceID: String, resourceType: String) {
        self.batch = batch
        self.code = code
        self.fhirVersion = fhirVersion
        self.form = form
        self.id = id
        self.identifier = identifier
        self.ingredient = ingredient
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
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
        batch: Batch? = nil,
        code: R4NlCorePharmaceuticalProductCode? = nil,
        fhirVersion: R4NlCoreHealthcareProviderFhirVersion? = nil,
        form: MgoCodeableConcept?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        ingredient: [R4NlCorePharmaceuticalProductIngredient]?? = nil,
        profile: R4NlCorePharmaceuticalProductProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil
    ) -> R4NlCorePharmaceuticalProduct {
        return R4NlCorePharmaceuticalProduct(
            batch: batch ?? self.batch,
            code: code ?? self.code,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            form: form ?? self.form,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            ingredient: ingredient ?? self.ingredient,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
