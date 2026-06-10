// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreEpisodeofcare = try NlCoreEpisodeofcare(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreEpisodeofcare
public struct NlCoreEpisodeofcare: Codable, Hashable, Sendable {
    public let fhirVersion: EAfspraakAppointmentFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let patient: MgoReference?
    public let period: MgoPeriod?
    public let profile: NlCoreEpisodeofcareProfile
    public let referenceID, resourceType: String
    public let title: ExtensionValueOfMgoString?
    public let type: [MgoCodeableConcept]?

    public enum CodingKeys: String, CodingKey {
        case fhirVersion, id, identifier, patient, period, profile
        case referenceID = "referenceId"
        case resourceType, title, type
    }

    public init(fhirVersion: EAfspraakAppointmentFhirVersion, id: String?, identifier: [MgoIdentifier]?, patient: MgoReference?, period: MgoPeriod?, profile: NlCoreEpisodeofcareProfile, referenceID: String, resourceType: String, title: ExtensionValueOfMgoString?, type: [MgoCodeableConcept]?) {
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.patient = patient
        self.period = period
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.title = title
        self.type = type
    }
}

// MARK: NlCoreEpisodeofcare convenience initializers and mutators

public extension NlCoreEpisodeofcare {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreEpisodeofcare.self, from: data)
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
        fhirVersion: EAfspraakAppointmentFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        patient: MgoReference?? = nil,
        period: MgoPeriod?? = nil,
        profile: NlCoreEpisodeofcareProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        title: ExtensionValueOfMgoString?? = nil,
        type: [MgoCodeableConcept]?? = nil
    ) -> NlCoreEpisodeofcare {
        return NlCoreEpisodeofcare(
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            patient: patient ?? self.patient,
            period: period ?? self.period,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            title: title ?? self.title,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
