// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpJournalEntry = try GpJournalEntry(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpJournalEntry
public struct GpJournalEntry: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let component: GpJournalEntryComponent?
    public let effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let effectivePeriod: MgoPeriod?
    public let episodeOfCare: [ExtensionValueOfMgoReference]
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let performer: [MgoReference]?
    public let profile: GpJournalEntryProfile
    public let referenceID, resourceType: String
    public let subject: MgoReference?
    public let valueString: PrimitiveValueTypeOfStringString?

    public enum CodingKeys: String, CodingKey {
        case code, component, effectiveDateTime, effectivePeriod, episodeOfCare, fhirVersion, id, identifier, performer, profile
        case referenceID = "referenceId"
        case resourceType, subject, valueString
    }

    public init(code: MgoCodeableConcept?, component: GpJournalEntryComponent?, effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?, effectivePeriod: MgoPeriod?, episodeOfCare: [ExtensionValueOfMgoReference], fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, performer: [MgoReference]?, profile: GpJournalEntryProfile, referenceID: String, resourceType: String, subject: MgoReference?, valueString: PrimitiveValueTypeOfStringString?) {
        self.code = code
        self.component = component
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.episodeOfCare = episodeOfCare
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.valueString = valueString
    }
}

// MARK: GpJournalEntry convenience initializers and mutators

public extension GpJournalEntry {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpJournalEntry.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        component: GpJournalEntryComponent?? = nil,
        effectiveDateTime: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        episodeOfCare: [ExtensionValueOfMgoReference]? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        performer: [MgoReference]?? = nil,
        profile: GpJournalEntryProfile? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        subject: MgoReference?? = nil,
        valueString: PrimitiveValueTypeOfStringString?? = nil
    ) -> GpJournalEntry {
        return GpJournalEntry(
            code: code ?? self.code,
            component: component ?? self.component,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            episodeOfCare: episodeOfCare ?? self.episodeOfCare,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject,
            valueString: valueString ?? self.valueString
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
