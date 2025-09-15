// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePatientIdentifier = try R4NlCorePatientIdentifier(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePatientIdentifier
public struct R4NlCorePatientIdentifier: Codable, Hashable, Sendable {
    public let bsn: MgoIdentifier?

    public init(bsn: MgoIdentifier?) {
        self.bsn = bsn
    }
}

// MARK: R4NlCorePatientIdentifier convenience initializers and mutators

public extension R4NlCorePatientIdentifier {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePatientIdentifier.self, from: data)
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
        bsn: MgoIdentifier?? = nil
    ) -> R4NlCorePatientIdentifier {
        return R4NlCorePatientIdentifier(
            bsn: bsn ?? self.bsn
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
