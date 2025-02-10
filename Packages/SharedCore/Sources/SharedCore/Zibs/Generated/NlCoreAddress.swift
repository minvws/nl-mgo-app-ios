// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreAddress = try NlCoreAddress(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreAddress
public struct NlCoreAddress: Codable, Hashable, Sendable {
    public let city, country, district: String?
    public let line: [String]?
    public let period: MgoPeriod?
    public let postalCode, state, text, type: String?
    public let use: String?

    public init(city: String?, country: String?, district: String?, line: [String]?, period: MgoPeriod?, postalCode: String?, state: String?, text: String?, type: String?, use: String?) {
        self.city = city
        self.country = country
        self.district = district
        self.line = line
        self.period = period
        self.postalCode = postalCode
        self.state = state
        self.text = text
        self.type = type
        self.use = use
    }
}

// MARK: NlCoreAddress convenience initializers and mutators

public extension NlCoreAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreAddress.self, from: data)
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
        city: String?? = nil,
        country: String?? = nil,
        district: String?? = nil,
        line: [String]?? = nil,
        period: MgoPeriod?? = nil,
        postalCode: String?? = nil,
        state: String?? = nil,
        text: String?? = nil,
        type: String?? = nil,
        use: String?? = nil
    ) -> NlCoreAddress {
        return NlCoreAddress(
            city: city ?? self.city,
            country: country ?? self.country,
            district: district ?? self.district,
            line: line ?? self.line,
            period: period ?? self.period,
            postalCode: postalCode ?? self.postalCode,
            state: state ?? self.state,
            text: text ?? self.text,
            type: type ?? self.type,
            use: use ?? self.use
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
