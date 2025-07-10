// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let additionalSources = try AdditionalSources(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - AdditionalSources
public struct AdditionalSources: Codable, Hashable, Sendable {
    public let ext: Bool
    public let valueAttachment: MgoAttachment?
    public let valueIdentifier: MgoIdentifier?
    public let valueReference: MgoReference?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case valueAttachment, valueIdentifier, valueReference
    }

    public init(ext: Bool, valueAttachment: MgoAttachment?, valueIdentifier: MgoIdentifier?, valueReference: MgoReference?) {
        self.ext = ext
        self.valueAttachment = valueAttachment
        self.valueIdentifier = valueIdentifier
        self.valueReference = valueReference
    }
}

// MARK: AdditionalSources convenience initializers and mutators

public extension AdditionalSources {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AdditionalSources.self, from: data)
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
        ext: Bool? = nil,
        valueAttachment: MgoAttachment?? = nil,
        valueIdentifier: MgoIdentifier?? = nil,
        valueReference: MgoReference?? = nil
    ) -> AdditionalSources {
        return AdditionalSources(
            ext: ext ?? self.ext,
            valueAttachment: valueAttachment ?? self.valueAttachment,
            valueIdentifier: valueIdentifier ?? self.valueIdentifier,
            valueReference: valueReference ?? self.valueReference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
