// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultSubstance = try ZibLaboratoryTestResultSubstance(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultSubstance
public struct ZibLaboratoryTestResultSubstance: Codable, Hashable, Sendable {
    public let category: [MgoCodeableConcept]?
    public let code: MgoCodeableConcept?
    public let description: String?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let profile: ZibLaboratoryTestResultSubstanceProfile
    public let referenceID: String
    public let resourceType, status: String?

    public enum CodingKeys: String, CodingKey {
        case category, code, description, fhirVersion, id, identifier, profile
        case referenceID = "referenceId"
        case resourceType, status
    }

    public init(category: [MgoCodeableConcept]?, code: MgoCodeableConcept?, description: String?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, profile: ZibLaboratoryTestResultSubstanceProfile, referenceID: String, resourceType: String?, status: String?) {
        self.category = category
        self.code = code
        self.description = description
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
    }
}

// MARK: ZibLaboratoryTestResultSubstance convenience initializers and mutators

public extension ZibLaboratoryTestResultSubstance {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultSubstance.self, from: data)
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
        category: [MgoCodeableConcept]?? = nil,
        code: MgoCodeableConcept?? = nil,
        description: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        profile: ZibLaboratoryTestResultSubstanceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: String?? = nil
    ) -> ZibLaboratoryTestResultSubstance {
        return ZibLaboratoryTestResultSubstance(
            category: category ?? self.category,
            code: code ?? self.code,
            description: description ?? self.description,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
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
