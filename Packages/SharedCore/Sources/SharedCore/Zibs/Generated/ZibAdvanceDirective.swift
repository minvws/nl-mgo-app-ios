// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAdvanceDirective = try ZibAdvanceDirective(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAdvanceDirective
public struct ZibAdvanceDirective: Codable, Hashable, Sendable {
    public let category: [MgoCodeableConcept]?
    public let comment: String?
    public let consentingParty: [MgoReference]?
    public let dateTime: String?
    public let disorder: MgoReference?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let profile: ZibAdvanceDirectiveProfile
    public let referenceID: String
    public let resourceType: String?
    public let source: Source
    public let typeOfLivingWill: [MgoCodeableConcept]?

    public enum CodingKeys: String, CodingKey {
        case category, comment, consentingParty, dateTime, disorder, fhirVersion, id, profile
        case referenceID = "referenceId"
        case resourceType, source, typeOfLivingWill
    }

    public init(category: [MgoCodeableConcept]?, comment: String?, consentingParty: [MgoReference]?, dateTime: String?, disorder: MgoReference?, fhirVersion: FhirVersionR3, id: String?, profile: ZibAdvanceDirectiveProfile, referenceID: String, resourceType: String?, source: Source, typeOfLivingWill: [MgoCodeableConcept]?) {
        self.category = category
        self.comment = comment
        self.consentingParty = consentingParty
        self.dateTime = dateTime
        self.disorder = disorder
        self.fhirVersion = fhirVersion
        self.id = id
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.source = source
        self.typeOfLivingWill = typeOfLivingWill
    }
}

// MARK: ZibAdvanceDirective convenience initializers and mutators

public extension ZibAdvanceDirective {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAdvanceDirective.self, from: data)
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
        comment: String?? = nil,
        consentingParty: [MgoReference]?? = nil,
        dateTime: String?? = nil,
        disorder: MgoReference?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        profile: ZibAdvanceDirectiveProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        source: Source? = nil,
        typeOfLivingWill: [MgoCodeableConcept]?? = nil
    ) -> ZibAdvanceDirective {
        return ZibAdvanceDirective(
            category: category ?? self.category,
            comment: comment ?? self.comment,
            consentingParty: consentingParty ?? self.consentingParty,
            dateTime: dateTime ?? self.dateTime,
            disorder: disorder ?? self.disorder,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            source: source ?? self.source,
            typeOfLivingWill: typeOfLivingWill ?? self.typeOfLivingWill
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
