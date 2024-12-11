// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibInstructionsForUse = try ZibInstructionsForUse(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibInstructionsForUse
public struct ZibInstructionsForUse: Codable, Hashable, Sendable {
    public let additionalInstruction: [MgoCodeableConcept]?
    public let asNeeded: MgoCodeableConcept?
    public let doseQuantity: MgoDuration?
    public let doseRange: MgoRange?
    public let maxDosePerPeriod: MgoRatio?
    public let rateQuantity: MgoDuration?
    public let rateRange: MgoRange?
    public let rateRatio: MgoRatio?
    public let route: MgoCodeableConcept?
    public let sequence: Double?
    public let text: String?
    public let timing: ZibAdministrationSchedule

    public init(additionalInstruction: [MgoCodeableConcept]?, asNeeded: MgoCodeableConcept?, doseQuantity: MgoDuration?, doseRange: MgoRange?, maxDosePerPeriod: MgoRatio?, rateQuantity: MgoDuration?, rateRange: MgoRange?, rateRatio: MgoRatio?, route: MgoCodeableConcept?, sequence: Double?, text: String?, timing: ZibAdministrationSchedule) {
        self.additionalInstruction = additionalInstruction
        self.asNeeded = asNeeded
        self.doseQuantity = doseQuantity
        self.doseRange = doseRange
        self.maxDosePerPeriod = maxDosePerPeriod
        self.rateQuantity = rateQuantity
        self.rateRange = rateRange
        self.rateRatio = rateRatio
        self.route = route
        self.sequence = sequence
        self.text = text
        self.timing = timing
    }
}

// MARK: ZibInstructionsForUse convenience initializers and mutators

public extension ZibInstructionsForUse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibInstructionsForUse.self, from: data)
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
        additionalInstruction: [MgoCodeableConcept]?? = nil,
        asNeeded: MgoCodeableConcept?? = nil,
        doseQuantity: MgoDuration?? = nil,
        doseRange: MgoRange?? = nil,
        maxDosePerPeriod: MgoRatio?? = nil,
        rateQuantity: MgoDuration?? = nil,
        rateRange: MgoRange?? = nil,
        rateRatio: MgoRatio?? = nil,
        route: MgoCodeableConcept?? = nil,
        sequence: Double?? = nil,
        text: String?? = nil,
        timing: ZibAdministrationSchedule? = nil
    ) -> ZibInstructionsForUse {
        return ZibInstructionsForUse(
            additionalInstruction: additionalInstruction ?? self.additionalInstruction,
            asNeeded: asNeeded ?? self.asNeeded,
            doseQuantity: doseQuantity ?? self.doseQuantity,
            doseRange: doseRange ?? self.doseRange,
            maxDosePerPeriod: maxDosePerPeriod ?? self.maxDosePerPeriod,
            rateQuantity: rateQuantity ?? self.rateQuantity,
            rateRange: rateRange ?? self.rateRange,
            rateRatio: rateRatio ?? self.rateRatio,
            route: route ?? self.route,
            sequence: sequence ?? self.sequence,
            text: text ?? self.text,
            timing: timing ?? self.timing
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
