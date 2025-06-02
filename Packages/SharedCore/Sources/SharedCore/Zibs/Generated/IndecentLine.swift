// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let indecentLine = try IndecentLine(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - IndecentLine
public struct IndecentLine: Codable, Hashable, Sendable {
    public let additionalInformation, countryCode, houseNumber, houseNumberAddition: MgoString?
    public let houseNumberIndiciation, houseNumberLetter, streetName: MgoString?

    public init(additionalInformation: MgoString?, countryCode: MgoString?, houseNumber: MgoString?, houseNumberAddition: MgoString?, houseNumberIndiciation: MgoString?, houseNumberLetter: MgoString?, streetName: MgoString?) {
        self.additionalInformation = additionalInformation
        self.countryCode = countryCode
        self.houseNumber = houseNumber
        self.houseNumberAddition = houseNumberAddition
        self.houseNumberIndiciation = houseNumberIndiciation
        self.houseNumberLetter = houseNumberLetter
        self.streetName = streetName
    }
}

// MARK: IndecentLine convenience initializers and mutators

public extension IndecentLine {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IndecentLine.self, from: data)
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
        additionalInformation: MgoString?? = nil,
        countryCode: MgoString?? = nil,
        houseNumber: MgoString?? = nil,
        houseNumberAddition: MgoString?? = nil,
        houseNumberIndiciation: MgoString?? = nil,
        houseNumberLetter: MgoString?? = nil,
        streetName: MgoString?? = nil
    ) -> IndecentLine {
        return IndecentLine(
            additionalInformation: additionalInformation ?? self.additionalInformation,
            countryCode: countryCode ?? self.countryCode,
            houseNumber: houseNumber ?? self.houseNumber,
            houseNumberAddition: houseNumberAddition ?? self.houseNumberAddition,
            houseNumberIndiciation: houseNumberIndiciation ?? self.houseNumberIndiciation,
            houseNumberLetter: houseNumberLetter ?? self.houseNumberLetter,
            streetName: streetName ?? self.streetName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
