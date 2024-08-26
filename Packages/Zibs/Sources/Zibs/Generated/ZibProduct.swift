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
    public let profile: String
    public let code: [MgoCoding]?
    public let description: String?
    public let form: [MgoCoding]?
    public let id: String?
    public let ingredient: [Ingredient]?
    public let package: Package
    public let resourceType: String?

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case code, description, form, id, ingredient, package, resourceType
    }

    public init(profile: String, code: [MgoCoding]?, description: String?, form: [MgoCoding]?, id: String?, ingredient: [Ingredient]?, package: Package, resourceType: String?) {
        self.profile = profile
        self.code = code
        self.description = description
        self.form = form
        self.id = id
        self.ingredient = ingredient
        self.package = package
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
        profile: String? = nil,
        code: [MgoCoding]?? = nil,
        description: String?? = nil,
        form: [MgoCoding]?? = nil,
        id: String?? = nil,
        ingredient: [Ingredient]?? = nil,
        package: Package? = nil,
        resourceType: String?? = nil
    ) -> ZibProduct {
        return ZibProduct(
            profile: profile ?? self.profile,
            code: code ?? self.code,
            description: description ?? self.description,
            form: form ?? self.form,
            id: id ?? self.id,
            ingredient: ingredient ?? self.ingredient,
            package: package ?? self.package,
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
