// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAlert = try ZibAlert(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAlert
public struct ZibAlert: Codable, Hashable, Sendable {
    public let author: MgoReference?
    public let category, code: MgoCodeableConcept?
    public let concernReference, encounter: MgoReference?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let period: MgoPeriod?
    public let profile: ZibAlertProfile
    public let referenceID: String
    public let resourceType: String?
    public let status: R4NlCorePharmaceuticalProductStatus?
    public let subject: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case author, category, code, concernReference, encounter, fhirVersion, id, identifier, period, profile
        case referenceID = "referenceId"
        case resourceType, status, subject
    }

    public init(author: MgoReference?, category: MgoCodeableConcept?, code: MgoCodeableConcept?, concernReference: MgoReference?, encounter: MgoReference?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, period: MgoPeriod?, profile: ZibAlertProfile, referenceID: String, resourceType: String?, status: R4NlCorePharmaceuticalProductStatus?, subject: MgoReference?) {
        self.author = author
        self.category = category
        self.code = code
        self.concernReference = concernReference
        self.encounter = encounter
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
        self.subject = subject
    }
}

// MARK: ZibAlert convenience initializers and mutators

public extension ZibAlert {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAlert.self, from: data)
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
        author: MgoReference?? = nil,
        category: MgoCodeableConcept?? = nil,
        code: MgoCodeableConcept?? = nil,
        concernReference: MgoReference?? = nil,
        encounter: MgoReference?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        period: MgoPeriod?? = nil,
        profile: ZibAlertProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: R4NlCorePharmaceuticalProductStatus?? = nil,
        subject: MgoReference?? = nil
    ) -> ZibAlert {
        return ZibAlert(
            author: author ?? self.author,
            category: category ?? self.category,
            code: code ?? self.code,
            concernReference: concernReference ?? self.concernReference,
            encounter: encounter ?? self.encounter,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
            subject: subject ?? self.subject
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
