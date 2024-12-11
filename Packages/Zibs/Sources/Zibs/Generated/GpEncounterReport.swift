// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpEncounterReport = try GpEncounterReport(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpEncounterReport
public struct GpEncounterReport: Codable, Hashable, Sendable {
    public let author: [MgoReference]?
    public let date: String?
    public let encounter: MgoReference?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: MgoIdentifier?
    public let profile: GpEncounterReportProfile
    public let referenceID: String
    public let resourceType: String?
    public let section: [Section]?
    public let status, title: String?
    public let type: [MgoCoding]?

    public enum CodingKeys: String, CodingKey {
        case author, date, encounter, fhirVersion, id, identifier, profile
        case referenceID = "referenceId"
        case resourceType, section, status, title, type
    }

    public init(author: [MgoReference]?, date: String?, encounter: MgoReference?, fhirVersion: FhirVersionR3, id: String?, identifier: MgoIdentifier?, profile: GpEncounterReportProfile, referenceID: String, resourceType: String?, section: [Section]?, status: String?, title: String?, type: [MgoCoding]?) {
        self.author = author
        self.date = date
        self.encounter = encounter
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.profile = profile
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.section = section
        self.status = status
        self.title = title
        self.type = type
    }
}

// MARK: GpEncounterReport convenience initializers and mutators

public extension GpEncounterReport {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpEncounterReport.self, from: data)
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
        author: [MgoReference]?? = nil,
        date: String?? = nil,
        encounter: MgoReference?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: MgoIdentifier?? = nil,
        profile: GpEncounterReportProfile? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        section: [Section]?? = nil,
        status: String?? = nil,
        title: String?? = nil,
        type: [MgoCoding]?? = nil
    ) -> GpEncounterReport {
        return GpEncounterReport(
            author: author ?? self.author,
            date: date ?? self.date,
            encounter: encounter ?? self.encounter,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            section: section ?? self.section,
            status: status ?? self.status,
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
