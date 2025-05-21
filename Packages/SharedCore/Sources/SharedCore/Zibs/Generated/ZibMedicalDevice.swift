// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibMedicalDevice = try ZibMedicalDevice(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicalDevice
public struct ZibMedicalDevice: Codable, Hashable, Sendable {
    public let bodySite: MgoCodeableConcept?
    public let device: MgoReference?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let laterality: MgoCodeableConcept?
    public let note: [MgoAnnotation]?
    public let organization, patient, practitioner: MgoReference?
    public let profile: ZibMedicalDeviceProfile
    public let reason: MgoReference?
    public let recordedOn: String?
    public let referenceID: String
    public let resourceType: String?
    public let source: MgoReference?
    public let status: ZibMedicalDeviceStatus?
    public let whenUsed: MgoPeriod?

    public enum CodingKeys: String, CodingKey {
        case bodySite, device, fhirVersion, id, identifier, laterality, note, organization, patient, practitioner, profile, reason, recordedOn
        case referenceID = "referenceId"
        case resourceType, source, status, whenUsed
    }

    public init(bodySite: MgoCodeableConcept?, device: MgoReference?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, laterality: MgoCodeableConcept?, note: [MgoAnnotation]?, organization: MgoReference?, patient: MgoReference?, practitioner: MgoReference?, profile: ZibMedicalDeviceProfile, reason: MgoReference?, recordedOn: String?, referenceID: String, resourceType: String?, source: MgoReference?, status: ZibMedicalDeviceStatus?, whenUsed: MgoPeriod?) {
        self.bodySite = bodySite
        self.device = device
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.laterality = laterality
        self.note = note
        self.organization = organization
        self.patient = patient
        self.practitioner = practitioner
        self.profile = profile
        self.reason = reason
        self.recordedOn = recordedOn
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.source = source
        self.status = status
        self.whenUsed = whenUsed
    }
}

// MARK: ZibMedicalDevice convenience initializers and mutators

public extension ZibMedicalDevice {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibMedicalDevice.self, from: data)
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
        bodySite: MgoCodeableConcept?? = nil,
        device: MgoReference?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        laterality: MgoCodeableConcept?? = nil,
        note: [MgoAnnotation]?? = nil,
        organization: MgoReference?? = nil,
        patient: MgoReference?? = nil,
        practitioner: MgoReference?? = nil,
        profile: ZibMedicalDeviceProfile? = nil,
        reason: MgoReference?? = nil,
        recordedOn: String?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        source: MgoReference?? = nil,
        status: ZibMedicalDeviceStatus?? = nil,
        whenUsed: MgoPeriod?? = nil
    ) -> ZibMedicalDevice {
        return ZibMedicalDevice(
            bodySite: bodySite ?? self.bodySite,
            device: device ?? self.device,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            laterality: laterality ?? self.laterality,
            note: note ?? self.note,
            organization: organization ?? self.organization,
            patient: patient ?? self.patient,
            practitioner: practitioner ?? self.practitioner,
            profile: profile ?? self.profile,
            reason: reason ?? self.reason,
            recordedOn: recordedOn ?? self.recordedOn,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            source: source ?? self.source,
            status: status ?? self.status,
            whenUsed: whenUsed ?? self.whenUsed
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
