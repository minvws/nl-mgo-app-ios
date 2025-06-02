// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibMedicationUseMedicationTreatment = try ZibMedicationUseMedicationTreatment(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicationUseMedicationTreatment
public struct ZibMedicationUseMedicationTreatment: Codable, Hashable, Sendable {
    public let ext: Bool
    public let type: IdentifierType
    public let system: String?
    public let medicationTreatmentType: IndecentType?
    public let use, value: String?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case type = "_type"
        case system
        case medicationTreatmentType = "type"
        case use, value
    }

    public init(ext: Bool, type: IdentifierType, system: String?, medicationTreatmentType: IndecentType?, use: String?, value: String?) {
        self.ext = ext
        self.type = type
        self.system = system
        self.medicationTreatmentType = medicationTreatmentType
        self.use = use
        self.value = value
    }
}

// MARK: ZibMedicationUseMedicationTreatment convenience initializers and mutators

public extension ZibMedicationUseMedicationTreatment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibMedicationUseMedicationTreatment.self, from: data)
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
        ext: Bool? = nil,
        type: IdentifierType? = nil,
        system: String?? = nil,
        medicationTreatmentType: IndecentType?? = nil,
        use: String?? = nil,
        value: String?? = nil
    ) -> ZibMedicationUseMedicationTreatment {
        return ZibMedicationUseMedicationTreatment(
            ext: ext ?? self.ext,
            type: type ?? self.type,
            system: system ?? self.system,
            medicationTreatmentType: medicationTreatmentType ?? self.medicationTreatmentType,
            use: use ?? self.use,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
