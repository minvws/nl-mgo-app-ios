// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibTreatmentDirectiveDatum = try ZibTreatmentDirectiveDatum(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibTreatmentDirectiveDatum
public struct ZibTreatmentDirectiveDatum: Codable, Hashable, Sendable {
    public let meaning: String?
    public let reference: MgoReference?

    public init(meaning: String?, reference: MgoReference?) {
        self.meaning = meaning
        self.reference = reference
    }
}

// MARK: ZibTreatmentDirectiveDatum convenience initializers and mutators

public extension ZibTreatmentDirectiveDatum {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibTreatmentDirectiveDatum.self, from: data)
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
        meaning: String?? = nil,
        reference: MgoReference?? = nil
    ) -> ZibTreatmentDirectiveDatum {
        return ZibTreatmentDirectiveDatum(
            meaning: meaning ?? self.meaning,
            reference: reference ?? self.reference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
