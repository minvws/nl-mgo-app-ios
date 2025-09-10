// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleBodySite = try PurpleBodySite(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - PurpleBodySite
public struct PurpleBodySite: Codable, Hashable, Sendable {
    public let type: MgoCodeableConceptType?
    public let coding: [MgoCodingProps]?
    public let laterality, morphology: [ExtensionValueOfMgoCodeableConcept]
    public let text: String?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case coding, laterality, morphology, text
    }

    public init(type: MgoCodeableConceptType?, coding: [MgoCodingProps]?, laterality: [ExtensionValueOfMgoCodeableConcept], morphology: [ExtensionValueOfMgoCodeableConcept], text: String?) {
        self.type = type
        self.coding = coding
        self.laterality = laterality
        self.morphology = morphology
        self.text = text
    }
}

// MARK: PurpleBodySite convenience initializers and mutators

public extension PurpleBodySite {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PurpleBodySite.self, from: data)
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
        type: MgoCodeableConceptType?? = nil,
        coding: [MgoCodingProps]?? = nil,
        laterality: [ExtensionValueOfMgoCodeableConcept]? = nil,
        morphology: [ExtensionValueOfMgoCodeableConcept]? = nil,
        text: String?? = nil
    ) -> PurpleBodySite {
        return PurpleBodySite(
            type: type ?? self.type,
            coding: coding ?? self.coding,
            laterality: laterality ?? self.laterality,
            morphology: morphology ?? self.morphology,
            text: text ?? self.text
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
