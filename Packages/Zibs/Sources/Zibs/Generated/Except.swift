// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let except = try Except(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Except
public struct Except: Codable, Hashable, Sendable {
    public let action: [MgoCodeableConcept]?
    public let actor: [ExceptActor]?
    public let exceptClass, code: [MgoCoding]?
    public let data: [ExceptDatum]?
    public let dataPeriod, period: MgoPeriod?
    public let purpose, securityLabel: [MgoCoding]?
    public let type: String?

    public enum CodingKeys: String, CodingKey {
        case action, actor
        case exceptClass = "class"
        case code, data, dataPeriod, period, purpose, securityLabel, type
    }

    public init(action: [MgoCodeableConcept]?, actor: [ExceptActor]?, exceptClass: [MgoCoding]?, code: [MgoCoding]?, data: [ExceptDatum]?, dataPeriod: MgoPeriod?, period: MgoPeriod?, purpose: [MgoCoding]?, securityLabel: [MgoCoding]?, type: String?) {
        self.action = action
        self.actor = actor
        self.exceptClass = exceptClass
        self.code = code
        self.data = data
        self.dataPeriod = dataPeriod
        self.period = period
        self.purpose = purpose
        self.securityLabel = securityLabel
        self.type = type
    }
}

// MARK: Except convenience initializers and mutators

public extension Except {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Except.self, from: data)
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
        action: [MgoCodeableConcept]?? = nil,
        actor: [ExceptActor]?? = nil,
        exceptClass: [MgoCoding]?? = nil,
        code: [MgoCoding]?? = nil,
        data: [ExceptDatum]?? = nil,
        dataPeriod: MgoPeriod?? = nil,
        period: MgoPeriod?? = nil,
        purpose: [MgoCoding]?? = nil,
        securityLabel: [MgoCoding]?? = nil,
        type: String?? = nil
    ) -> Except {
        return Except(
            action: action ?? self.action,
            actor: actor ?? self.actor,
            exceptClass: exceptClass ?? self.exceptClass,
            code: code ?? self.code,
            data: data ?? self.data,
            dataPeriod: dataPeriod ?? self.dataPeriod,
            period: period ?? self.period,
            purpose: purpose ?? self.purpose,
            securityLabel: securityLabel ?? self.securityLabel,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
