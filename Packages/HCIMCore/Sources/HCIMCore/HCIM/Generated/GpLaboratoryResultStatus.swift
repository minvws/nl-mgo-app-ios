// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gpLaboratoryResultStatus = try GpLaboratoryResultStatus(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - GpLaboratoryResultStatus
public struct GpLaboratoryResultStatus: Codable, Hashable, Sendable {
    public let type: MgoCodeType?
    public let testResultStatus: ExtensionValueOfMgoCodeableConcept?
    public let value: PurpleValue?

    public enum CodingKeys: String, CodingKey {
        case type = "_type"
        case testResultStatus, value
    }

    public init(type: MgoCodeType?, testResultStatus: ExtensionValueOfMgoCodeableConcept?, value: PurpleValue?) {
        self.type = type
        self.testResultStatus = testResultStatus
        self.value = value
    }
}

// MARK: GpLaboratoryResultStatus convenience initializers and mutators

public extension GpLaboratoryResultStatus {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GpLaboratoryResultStatus.self, from: data)
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
        type: MgoCodeType?? = nil,
        testResultStatus: ExtensionValueOfMgoCodeableConcept?? = nil,
        value: PurpleValue?? = nil
    ) -> GpLaboratoryResultStatus {
        return GpLaboratoryResultStatus(
            type: type ?? self.type,
            testResultStatus: testResultStatus ?? self.testResultStatus,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
