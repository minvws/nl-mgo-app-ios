// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibProduct = try ZibProduct(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProduct
public struct ZibProduct: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let description: String?
    public let fhirVersion: FhirVersionR3
    public let form: MgoCodeableConcept?
    public let id: String?
    public let ingredient: [ZibProductIngredient]?
    public let package: Package
    public let profile: ZibProductProfile
    public let referenceID: String
    public let resourceType: String?

    public enum CodingKeys: String, CodingKey {
        case code, description, fhirVersion, form, id, ingredient, package, profile
        case referenceID = "referenceId"
        case resourceType
    }

    public init(code: MgoCodeableConcept?, description: String?, fhirVersion: FhirVersionR3, form: MgoCodeableConcept?, id: String?, ingredient: [ZibProductIngredient]?, package: Package, profile: ZibProductProfile, referenceID: String, resourceType: String?) {
        self.code = code
        self.description = description
        self.fhirVersion = fhirVersion
        self.form = form
        self.id = id
        self.ingredient = ingredient
        self.package = package
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
    }
}

// MARK: ZibProduct convenience initializers and mutators

public extension ZibProduct {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibProduct.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        description: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        form: MgoCodeableConcept?? = nil,
        id: String?? = nil,
        ingredient: [ZibProductIngredient]?? = nil,
        package: Package? = nil,
        profile: ZibProductProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil
    ) -> ZibProduct {
        return ZibProduct(
            code: code ?? self.code,
            description: description ?? self.description,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            form: form ?? self.form,
            id: id ?? self.id,
            ingredient: ingredient ?? self.ingredient,
            package: package ?? self.package,
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
