// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let qualification = try Qualification(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Qualification
public struct Qualification: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let identifier: [MgoIdentifier]?
    public let issuer: MgoReference?
    public let period: MgoPeriod?

    public init(code: MgoCodeableConcept?, identifier: [MgoIdentifier]?, issuer: MgoReference?, period: MgoPeriod?) {
        self.code = code
        self.identifier = identifier
        self.issuer = issuer
        self.period = period
    }
}

// MARK: Qualification convenience initializers and mutators

public extension Qualification {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Qualification.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        issuer: MgoReference?? = nil,
        period: MgoPeriod?? = nil
    ) -> Qualification {
        return Qualification(
            code: code ?? self.code,
            identifier: identifier ?? self.identifier,
            issuer: issuer ?? self.issuer,
            period: period ?? self.period
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
