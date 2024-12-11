// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibMedicalDeviceProduct = try ZibMedicalDeviceProduct(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicalDeviceProduct
public struct ZibMedicalDeviceProduct: Codable, Hashable, Sendable {
    public let expirationDate: String?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let note: [MgoAnnotation]?
    public let patient: MgoReference?
    public let profile: ZibMedicalDeviceProductProfile
    public let referenceID: String
    public let resourceType: String?

    public enum CodingKeys: String, CodingKey {
        case expirationDate, fhirVersion, id, note, patient, profile
        case referenceID = "referenceId"
        case resourceType
    }

    public init(expirationDate: String?, fhirVersion: FhirVersionR3, id: String?, note: [MgoAnnotation]?, patient: MgoReference?, profile: ZibMedicalDeviceProductProfile, referenceID: String, resourceType: String?) {
        self.expirationDate = expirationDate
        self.fhirVersion = fhirVersion
        self.id = id
        self.note = note
        self.patient = patient
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
    }
}

// MARK: ZibMedicalDeviceProduct convenience initializers and mutators

public extension ZibMedicalDeviceProduct {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibMedicalDeviceProduct.self, from: data)
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
        expirationDate: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        note: [MgoAnnotation]?? = nil,
        patient: MgoReference?? = nil,
        profile: ZibMedicalDeviceProductProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil
    ) -> ZibMedicalDeviceProduct {
        return ZibMedicalDeviceProduct(
            expirationDate: expirationDate ?? self.expirationDate,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            note: note ?? self.note,
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
