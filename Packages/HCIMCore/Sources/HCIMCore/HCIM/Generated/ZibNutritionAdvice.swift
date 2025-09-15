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
    public let comment: ExtensionValueOfMgoString?
    public let dateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let oralDiet: OralDiet
    public let orderer, patient: MgoReference?
    public let profile: ZibNutritionAdviceProfile
    public let referenceID, resourceType: String

    public enum CodingKeys: String, CodingKey {
        case comment, dateTime, fhirVersion, id, identifier, oralDiet, orderer, patient, profile
        case referenceID = "referenceId"
        case resourceType
    }

    public init(comment: ExtensionValueOfMgoString?, dateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, oralDiet: OralDiet, orderer: MgoReference?, patient: MgoReference?, profile: ZibNutritionAdviceProfile, referenceID: String, resourceType: String) {
        self.comment = comment
        self.dateTime = dateTime
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.oralDiet = oralDiet
        self.orderer = orderer
        self.patient = patient
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
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
        comment: ExtensionValueOfMgoString?? = nil,
        dateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        oralDiet: OralDiet? = nil,
        orderer: MgoReference?? = nil,
        patient: MgoReference?? = nil,
        profile: ZibNutritionAdviceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil
    ) -> ZibNutritionAdvice {
        return ZibNutritionAdvice(
            comment: comment ?? self.comment,
            dateTime: dateTime ?? self.dateTime,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            oralDiet: oralDiet ?? self.oralDiet,
            orderer: orderer ?? self.orderer,
            patient: patient ?? self.patient,
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
