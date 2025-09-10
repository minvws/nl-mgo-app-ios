// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibProcedureRequestBodySite = try ZibProcedureRequestBodySite(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProcedureRequestBodySite
public struct ZibProcedureRequestBodySite: Codable, Hashable, Sendable {
    public let type: MgoCodeableConceptType?
    public let coding: [MgoCodingProps]?
    public let procedureLaterality: ExtensionValueOfMgoCodeableConcept?
    public let text: String?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case coding, procedureLaterality, text
    }

    public init(type: MgoCodeableConceptType?, coding: [MgoCodingProps]?, procedureLaterality: ExtensionValueOfMgoCodeableConcept?, text: String?) {
        self.type = type
        self.coding = coding
        self.procedureLaterality = procedureLaterality
        self.text = text
    }
}

// MARK: ZibProcedureRequestBodySite convenience initializers and mutators

public extension ZibProcedureRequestBodySite {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibProcedureRequestBodySite.self, from: data)
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
        procedureLaterality: ExtensionValueOfMgoCodeableConcept?? = nil,
        text: String?? = nil
    ) -> ZibProcedureRequestBodySite {
        return ZibProcedureRequestBodySite(
            type: type ?? self.type,
            coding: coding ?? self.coding,
            procedureLaterality: procedureLaterality ?? self.procedureLaterality,
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
