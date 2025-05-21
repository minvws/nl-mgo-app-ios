// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibNutritionAdvice = try ZibNutritionAdvice(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibNutritionAdvice
public struct ZibNutritionAdvice: Codable, Hashable, Sendable {
    public let comment, dateTime: String?
    public let fhirVersion: FhirVersionR3
    public let foodPreferenceModifier: [MgoCodeableConcept]?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let patient: MgoReference?
    public let profile: ZibNutritionAdviceProfile
    public let referenceID: String
    public let resourceType: String?
    public let status: ZibNutritionAdviceStatus?

    public enum CodingKeys: String, CodingKey {
        case comment, dateTime, fhirVersion, foodPreferenceModifier, id, identifier, patient, profile
        case referenceID = "referenceId"
        case resourceType, status
    }

    public init(comment: String?, dateTime: String?, fhirVersion: FhirVersionR3, foodPreferenceModifier: [MgoCodeableConcept]?, id: String?, identifier: [MgoIdentifier]?, patient: MgoReference?, profile: ZibNutritionAdviceProfile, referenceID: String, resourceType: String?, status: ZibNutritionAdviceStatus?) {
        self.comment = comment
        self.dateTime = dateTime
        self.fhirVersion = fhirVersion
        self.foodPreferenceModifier = foodPreferenceModifier
        self.id = id
        self.identifier = identifier
        self.patient = patient
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
    }
}

// MARK: ZibNutritionAdvice convenience initializers and mutators

public extension ZibNutritionAdvice {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibNutritionAdvice.self, from: data)
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
        comment: String?? = nil,
        dateTime: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        foodPreferenceModifier: [MgoCodeableConcept]?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        patient: MgoReference?? = nil,
        profile: ZibNutritionAdviceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: ZibNutritionAdviceStatus?? = nil
    ) -> ZibNutritionAdvice {
        return ZibNutritionAdvice(
            comment: comment ?? self.comment,
            dateTime: dateTime ?? self.dateTime,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            foodPreferenceModifier: foodPreferenceModifier ?? self.foodPreferenceModifier,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            patient: patient ?? self.patient,
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
