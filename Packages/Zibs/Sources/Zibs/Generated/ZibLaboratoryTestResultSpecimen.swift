// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultSpecimen = try ZibLaboratoryTestResultSpecimen(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultSpecimen
public struct ZibLaboratoryTestResultSpecimen: Codable, Hashable, Sendable {
    public let collection: Collection
    public let container: [Container]?
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let note: [MgoAnnotation]?
    public let profile: ZibLaboratoryTestResultSpecimenProfile
    public let receivedTime: String?
    public let referenceID: String
    public let resourceType: String?
    public let subject: MgoReference?
    public let substance: String?
    public let type: [MgoCoding]?

    public enum CodingKeys: String, CodingKey {
        case collection, container, id, identifier, note, profile, receivedTime
        case referenceID = "referenceId"
        case resourceType, subject, substance, type
    }

    public init(collection: Collection, container: [Container]?, id: String?, identifier: [MgoIdentifier]?, note: [MgoAnnotation]?, profile: ZibLaboratoryTestResultSpecimenProfile, receivedTime: String?, referenceID: String, resourceType: String?, subject: MgoReference?, substance: String?, type: [MgoCoding]?) {
        self.collection = collection
        self.container = container
        self.id = id
        self.identifier = identifier
        self.note = note
        self.profile = profile
        self.receivedTime = receivedTime
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.substance = substance
        self.type = type
    }
}

// MARK: ZibLaboratoryTestResultSpecimen convenience initializers and mutators

public extension ZibLaboratoryTestResultSpecimen {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultSpecimen.self, from: data)
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
        collection: Collection? = nil,
        container: [Container]?? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        note: [MgoAnnotation]?? = nil,
        profile: ZibLaboratoryTestResultSpecimenProfile? = nil,
        receivedTime: String?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        subject: MgoReference?? = nil,
        substance: String?? = nil,
        type: [MgoCoding]?? = nil
    ) -> ZibLaboratoryTestResultSpecimen {
        return ZibLaboratoryTestResultSpecimen(
            collection: collection ?? self.collection,
            container: container ?? self.container,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            note: note ?? self.note,
            profile: profile ?? self.profile,
            receivedTime: receivedTime ?? self.receivedTime,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject,
            substance: substance ?? self.substance,
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
