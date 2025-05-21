// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCoreHumanname = try NlCoreHumanname(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCoreHumanname
public struct NlCoreHumanname: Codable, Hashable, Sendable {
    public let family: String?
    public let given: [String]?
    public let period: MgoPeriod?
    public let nlCoreHumannamePrefix, suffix: [String]?
    public let text, use: String?

    public enum CodingKeys: String, CodingKey {
        case family, given, period
        case nlCoreHumannamePrefix = "prefix"
        case suffix, text, use
    }

    public init(family: String?, given: [String]?, period: MgoPeriod?, nlCoreHumannamePrefix: [String]?, suffix: [String]?, text: String?, use: String?) {
        self.family = family
        self.given = given
        self.period = period
        self.nlCoreHumannamePrefix = nlCoreHumannamePrefix
        self.suffix = suffix
        self.text = text
        self.use = use
    }
}

// MARK: NlCoreHumanname convenience initializers and mutators

public extension NlCoreHumanname {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCoreHumanname.self, from: data)
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
        family: String?? = nil,
        given: [String]?? = nil,
        period: MgoPeriod?? = nil,
        nlCoreHumannamePrefix: [String]?? = nil,
        suffix: [String]?? = nil,
        text: String?? = nil,
        use: String?? = nil
    ) -> NlCoreHumanname {
        return NlCoreHumanname(
            family: family ?? self.family,
            given: given ?? self.given,
            period: period ?? self.period,
            nlCoreHumannamePrefix: nlCoreHumannamePrefix ?? self.nlCoreHumannamePrefix,
            suffix: suffix ?? self.suffix,
            text: text ?? self.text,
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
