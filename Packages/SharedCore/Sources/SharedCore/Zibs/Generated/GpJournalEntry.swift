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
    public let context: MgoReference?
    public let effectiveDateTime: String?
    public let effectivePeriod: MgoPeriod?
    public let fhirVersion: FhirVersionR3
    public let icpcE: IcpcE
    public let icpcS: IcpcS
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let performer: [MgoReference]?
    public let profile: GpJournalEntryProfile
    public let referenceID: String
    public let resourceType, status, valueString: String?

    public enum CodingKeys: String, CodingKey {
        case code, context, effectiveDateTime, effectivePeriod, fhirVersion
        case icpcE = "ICPC_E"
        case icpcS = "ICPC_S"
        case id, identifier, performer, profile
        case referenceID = "referenceId"
        case resourceType, status, valueString
    }

    public init(code: MgoCodeableConcept?, context: MgoReference?, effectiveDateTime: String?, effectivePeriod: MgoPeriod?, fhirVersion: FhirVersionR3, icpcE: IcpcE, icpcS: IcpcS, id: String?, identifier: [MgoIdentifier]?, performer: [MgoReference]?, profile: GpJournalEntryProfile, referenceID: String, resourceType: String?, status: String?, valueString: String?) {
        self.code = code
        self.context = context
        self.effectiveDateTime = effectiveDateTime
        self.effectivePeriod = effectivePeriod
        self.fhirVersion = fhirVersion
        self.icpcE = icpcE
        self.icpcS = icpcS
        self.id = id
        self.identifier = identifier
        self.performer = performer
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.status = status
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
        context: MgoReference?? = nil,
        effectiveDateTime: String?? = nil,
        effectivePeriod: MgoPeriod?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        icpcE: IcpcE? = nil,
        icpcS: IcpcS? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        performer: [MgoReference]?? = nil,
        profile: GpJournalEntryProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        status: String?? = nil,
        valueString: String?? = nil
    ) -> GpJournalEntry {
        return GpJournalEntry(
            code: code ?? self.code,
            context: context ?? self.context,
            effectiveDateTime: effectiveDateTime ?? self.effectiveDateTime,
            effectivePeriod: effectivePeriod ?? self.effectivePeriod,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            icpcE: icpcE ?? self.icpcE,
            icpcS: icpcS ?? self.icpcS,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            performer: performer ?? self.performer,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            status: status ?? self.status,
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
