// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultSpecimenIsolate = try ZibLaboratoryTestResultSpecimenIsolate(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultSpecimenIsolate
public struct ZibLaboratoryTestResultSpecimenIsolate: Codable, Hashable, Sendable {
    public let collection: ZibLaboratoryTestResultSpecimenIsolateCollection
    public let container: [ZibLaboratoryTestResultSpecimenIsolateContainer]?
    public let fhirVersion: FhirVersionR3
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let note: [MgoAnnotation]?
    public let profile: ZibLaboratoryTestResultSpecimenIsolateProfile
    public let receivedTime: String?
    public let referenceID: String
    public let resourceType: String?
    public let subject: MgoReference?
    public let type: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case collection, container, fhirVersion, id, identifier, note, profile, receivedTime
        case referenceID = "referenceId"
        case resourceType, subject, type
    }

    public init(collection: ZibLaboratoryTestResultSpecimenIsolateCollection, container: [ZibLaboratoryTestResultSpecimenIsolateContainer]?, fhirVersion: FhirVersionR3, id: String?, identifier: [MgoIdentifier]?, note: [MgoAnnotation]?, profile: ZibLaboratoryTestResultSpecimenIsolateProfile, receivedTime: String?, referenceID: String, resourceType: String?, subject: MgoReference?, type: MgoCodeableConcept?) {
        self.collection = collection
        self.container = container
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.note = note
        self.profile = profile
        self.receivedTime = receivedTime
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.subject = subject
        self.type = type
    }
}

// MARK: ZibLaboratoryTestResultSpecimenIsolate convenience initializers and mutators

public extension ZibLaboratoryTestResultSpecimenIsolate {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultSpecimenIsolate.self, from: data)
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
        collection: ZibLaboratoryTestResultSpecimenIsolateCollection? = nil,
        container: [ZibLaboratoryTestResultSpecimenIsolateContainer]?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        note: [MgoAnnotation]?? = nil,
        profile: ZibLaboratoryTestResultSpecimenIsolateProfile? = nil,
        receivedTime: String?? = nil,
        referenceID: String? = nil,
        resourceType: String?? = nil,
        subject: MgoReference?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> ZibLaboratoryTestResultSpecimenIsolate {
        return ZibLaboratoryTestResultSpecimenIsolate(
            collection: collection ?? self.collection,
            container: container ?? self.container,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            note: note ?? self.note,
            profile: profile ?? self.profile,
            receivedTime: receivedTime ?? self.receivedTime,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            subject: subject ?? self.subject,
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
