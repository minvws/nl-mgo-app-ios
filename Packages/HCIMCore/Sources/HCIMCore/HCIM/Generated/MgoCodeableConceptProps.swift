// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoCodeableConceptProps = try MgoCodeableConceptProps(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoCodeableConceptProps
public struct MgoCodeableConceptProps: Codable, Hashable, Sendable {
    public let coding: [DisplayValue]
    public let text: String?

    public init(coding: [DisplayValue], text: String?) {
        self.coding = coding
        self.text = text
    }
}

// MARK: MgoCodeableConceptProps convenience initializers and mutators

public extension MgoCodeableConceptProps {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoCodeableConceptProps.self, from: data)
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
        coding: [DisplayValue]? = nil,
        text: String?? = nil
    ) -> MgoCodeableConceptProps {
        return MgoCodeableConceptProps(
            coding: coding ?? self.coding,
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
