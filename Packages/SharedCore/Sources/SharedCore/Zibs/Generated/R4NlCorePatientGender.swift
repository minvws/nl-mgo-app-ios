// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let r4NlCorePatientGender = try R4NlCorePatientGender(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - R4NlCorePatientGender
public struct R4NlCorePatientGender: Codable, Hashable, Sendable {
    public let genderCodeList: GenderCodeList?

    public init(genderCodeList: GenderCodeList?) {
        self.genderCodeList = genderCodeList
    }
}

// MARK: R4NlCorePatientGender convenience initializers and mutators

public extension R4NlCorePatientGender {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(R4NlCorePatientGender.self, from: data)
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
        genderCodeList: GenderCodeList?? = nil
    ) -> R4NlCorePatientGender {
        return R4NlCorePatientGender(
            genderCodeList: genderCodeList ?? self.genderCodeList
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
