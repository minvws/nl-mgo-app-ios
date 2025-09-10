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
    public let bodySite: ZibMedicalDeviceBodySite
    public let device: MgoReference?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let healthCareProvider, healthProfessional: ExtensionValueOfMgoReference?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let indicationProblem: [IndicationProblem]?
    public let note: [MgoAnnotation]?
    public let profile: ZibMedicalDeviceProfile
    public let referenceID, resourceType: String
    public let source, subject: MgoReference?
    public let whenUsed: MgoPeriod?

    public enum CodingKeys: String, CodingKey {
        case bodySite, device, fhirVersion, healthCareProvider, healthProfessional, id, identifier, indicationProblem, note, profile
        case referenceID = "referenceId"
        case resourceType, source, subject, whenUsed
    }

    public init(bodySite: ZibMedicalDeviceBodySite, device: MgoReference?, fhirVersion: NlCoreObservationFhirVersion, healthCareProvider: ExtensionValueOfMgoReference?, healthProfessional: ExtensionValueOfMgoReference?, id: String?, identifier: [MgoIdentifier]?, indicationProblem: [IndicationProblem]?, note: [MgoAnnotation]?, profile: ZibMedicalDeviceProfile, referenceID: String, resourceType: String, source: MgoReference?, subject: MgoReference?, whenUsed: MgoPeriod?) {
        self.bodySite = bodySite
        self.device = device
        self.fhirVersion = fhirVersion
        self.healthCareProvider = healthCareProvider
        self.healthProfessional = healthProfessional
        self.id = id
        self.identifier = identifier
        self.indicationProblem = indicationProblem
        self.note = note
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.source = source
        self.subject = subject
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
        bodySite: ZibMedicalDeviceBodySite? = nil,
        device: MgoReference?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        healthCareProvider: ExtensionValueOfMgoReference?? = nil,
        healthProfessional: ExtensionValueOfMgoReference?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        indicationProblem: [IndicationProblem]?? = nil,
        note: [MgoAnnotation]?? = nil,
        profile: ZibMedicalDeviceProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        source: MgoReference?? = nil,
        subject: MgoReference?? = nil,
        whenUsed: MgoPeriod?? = nil
    ) -> ZibMedicalDevice {
        return ZibMedicalDevice(
            bodySite: bodySite ?? self.bodySite,
            device: device ?? self.device,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            healthCareProvider: healthCareProvider ?? self.healthCareProvider,
            healthProfessional: healthProfessional ?? self.healthProfessional,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            indicationProblem: indicationProblem ?? self.indicationProblem,
            note: note ?? self.note,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            source: source ?? self.source,
            subject: subject ?? self.subject,
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
