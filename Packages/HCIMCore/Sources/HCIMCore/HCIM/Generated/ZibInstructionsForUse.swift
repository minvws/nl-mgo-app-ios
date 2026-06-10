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
    public let profile: DossageInstructionProfile
    public let additionalInstruction: [MgoCodeableConcept]?
    public let asNeededCodeableConcept: MgoCodeableConcept?
    public let doseQuantity: MgoQuantityProps?
    public let doseRange: MgoRange?
    public let maxDosePerPeriod: MgoRatio?
    public let rateQuantity: MgoQuantityProps?
    public let rateRange: MgoRange?
    public let rateRatio: MgoRatio?
    public let route: MgoCodeableConcept?
    public let sequence: MgoInteger?
    public let text: MgoString?
    public let timing: ZibAdministrationSchedule

    public enum CodingKeys: String, CodingKey {
        case profile = "_profile"
        case additionalInstruction, asNeededCodeableConcept, doseQuantity, doseRange, maxDosePerPeriod, rateQuantity, rateRange, rateRatio, route, sequence, text, timing
    }

    public init(profile: DossageInstructionProfile, additionalInstruction: [MgoCodeableConcept]?, asNeededCodeableConcept: MgoCodeableConcept?, doseQuantity: MgoQuantityProps?, doseRange: MgoRange?, maxDosePerPeriod: MgoRatio?, rateQuantity: MgoQuantityProps?, rateRange: MgoRange?, rateRatio: MgoRatio?, route: MgoCodeableConcept?, sequence: MgoInteger?, text: MgoString?, timing: ZibAdministrationSchedule) {
        self.profile = profile
        self.additionalInstruction = additionalInstruction
        self.asNeededCodeableConcept = asNeededCodeableConcept
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
        profile: DossageInstructionProfile? = nil,
        additionalInstruction: [MgoCodeableConcept]?? = nil,
        asNeededCodeableConcept: MgoCodeableConcept?? = nil,
        doseQuantity: MgoQuantityProps?? = nil,
        doseRange: MgoRange?? = nil,
        maxDosePerPeriod: MgoRatio?? = nil,
        rateQuantity: MgoQuantityProps?? = nil,
        rateRange: MgoRange?? = nil,
        rateRatio: MgoRatio?? = nil,
        route: MgoCodeableConcept?? = nil,
        sequence: MgoInteger?? = nil,
        text: MgoString?? = nil,
        timing: ZibAdministrationSchedule? = nil
    ) -> ZibInstructionsForUse {
        return ZibInstructionsForUse(
            profile: profile ?? self.profile,
            additionalInstruction: additionalInstruction ?? self.additionalInstruction,
            asNeededCodeableConcept: asNeededCodeableConcept ?? self.asNeededCodeableConcept,
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
