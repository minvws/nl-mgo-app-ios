// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nlCorePractitionerIdentifier = try NlCorePractitionerIdentifier(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NlCorePractitionerIdentifier
public struct NlCorePractitionerIdentifier: Codable, Hashable, Sendable {
    public let agb, big: MgoIdentifier?
    public let other: [MgoIdentifier]?
    public let uzi: MgoIdentifier?

    public init(agb: MgoIdentifier?, big: MgoIdentifier?, other: [MgoIdentifier]?, uzi: MgoIdentifier?) {
        self.agb = agb
        self.big = big
        self.other = other
        self.uzi = uzi
    }
}

// MARK: NlCorePractitionerIdentifier convenience initializers and mutators

public extension NlCorePractitionerIdentifier {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NlCorePractitionerIdentifier.self, from: data)
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
        agb: MgoIdentifier?? = nil,
        big: MgoIdentifier?? = nil,
        other: [MgoIdentifier]?? = nil,
        uzi: MgoIdentifier?? = nil
    ) -> NlCorePractitionerIdentifier {
        return NlCorePractitionerIdentifier(
            agb: agb ?? self.agb,
            big: big ?? self.big,
            other: other ?? self.other,
            uzi: uzi ?? self.uzi
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
