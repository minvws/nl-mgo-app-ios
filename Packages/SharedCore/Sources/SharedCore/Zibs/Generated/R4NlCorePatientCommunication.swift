// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePatientCommunication = try R4NlCorePatientCommunication(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePatientCommunication
public struct R4NlCorePatientCommunication: Codable, Hashable, Sendable {
    public let comment: [FluffyComment]
    public let language: MgoCodeableConcept?
    public let languageProficiency: FluffyLanguageProficiency

    public init(comment: [FluffyComment], language: MgoCodeableConcept?, languageProficiency: FluffyLanguageProficiency) {
        self.comment = comment
        self.language = language
        self.languageProficiency = languageProficiency
    }
}

// MARK: R4NlCorePatientCommunication convenience initializers and mutators

public extension R4NlCorePatientCommunication {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePatientCommunication.self, from: data)
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
        comment: [FluffyComment]? = nil,
        language: MgoCodeableConcept?? = nil,
        languageProficiency: FluffyLanguageProficiency? = nil
    ) -> R4NlCorePatientCommunication {
        return R4NlCorePatientCommunication(
            comment: comment ?? self.comment,
            language: language ?? self.language,
            languageProficiency: languageProficiency ?? self.languageProficiency
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
