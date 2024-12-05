// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let protocolApplied = try ProtocolApplied(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ProtocolApplied
public struct ProtocolApplied: Codable, Hashable, Sendable {
    public let authority: MgoReference?
    public let doseNumberPositiveInt: Double?
    public let doseNumberString: String?
    public let seriesDosesPositiveInt: Double?
    public let seriesDosesString: String?
    public let targetDisease: [MgoCodeableConcept]?

    public init(authority: MgoReference?, doseNumberPositiveInt: Double?, doseNumberString: String?, seriesDosesPositiveInt: Double?, seriesDosesString: String?, targetDisease: [MgoCodeableConcept]?) {
        self.authority = authority
        self.doseNumberPositiveInt = doseNumberPositiveInt
        self.doseNumberString = doseNumberString
        self.seriesDosesPositiveInt = seriesDosesPositiveInt
        self.seriesDosesString = seriesDosesString
        self.targetDisease = targetDisease
    }
}

// MARK: ProtocolApplied convenience initializers and mutators

public extension ProtocolApplied {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProtocolApplied.self, from: data)
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
        authority: MgoReference?? = nil,
        doseNumberPositiveInt: Double?? = nil,
        doseNumberString: String?? = nil,
        seriesDosesPositiveInt: Double?? = nil,
        seriesDosesString: String?? = nil,
        targetDisease: [MgoCodeableConcept]?? = nil
    ) -> ProtocolApplied {
        return ProtocolApplied(
            authority: authority ?? self.authority,
            doseNumberPositiveInt: doseNumberPositiveInt ?? self.doseNumberPositiveInt,
            doseNumberString: doseNumberString ?? self.doseNumberString,
            seriesDosesPositiveInt: seriesDosesPositiveInt ?? self.seriesDosesPositiveInt,
            seriesDosesString: seriesDosesString ?? self.seriesDosesString,
            targetDisease: targetDisease ?? self.targetDisease
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
