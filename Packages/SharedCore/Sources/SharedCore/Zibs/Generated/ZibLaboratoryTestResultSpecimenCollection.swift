// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibLaboratoryTestResultSpecimenCollection = try ZibLaboratoryTestResultSpecimenCollection(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibLaboratoryTestResultSpecimenCollection
public struct ZibLaboratoryTestResultSpecimenCollection: Codable, Hashable, Sendable {
    public let bodySite: PurpleBodySite
    public let collectedDateTime: String?
    public let collectedPeriod: MgoPeriod?
    public let method: MgoCodeableConcept?
    public let quantity: MgoDuration?

    public init(bodySite: PurpleBodySite, collectedDateTime: String?, collectedPeriod: MgoPeriod?, method: MgoCodeableConcept?, quantity: MgoDuration?) {
        self.bodySite = bodySite
        self.collectedDateTime = collectedDateTime
        self.collectedPeriod = collectedPeriod
        self.method = method
        self.quantity = quantity
    }
}

// MARK: ZibLaboratoryTestResultSpecimenCollection convenience initializers and mutators

public extension ZibLaboratoryTestResultSpecimenCollection {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibLaboratoryTestResultSpecimenCollection.self, from: data)
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
        bodySite: PurpleBodySite? = nil,
        collectedDateTime: String?? = nil,
        collectedPeriod: MgoPeriod?? = nil,
        method: MgoCodeableConcept?? = nil,
        quantity: MgoDuration?? = nil
    ) -> ZibLaboratoryTestResultSpecimenCollection {
        return ZibLaboratoryTestResultSpecimenCollection(
            bodySite: bodySite ?? self.bodySite,
            collectedDateTime: collectedDateTime ?? self.collectedDateTime,
            collectedPeriod: collectedPeriod ?? self.collectedPeriod,
            method: method ?? self.method,
            quantity: quantity ?? self.quantity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
