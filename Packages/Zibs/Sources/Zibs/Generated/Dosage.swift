// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dosage = try Dosage(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Dosage
public struct Dosage: Codable, Hashable, Sendable {
    public let additionalInstruction: [[MgoCoding]]?
    public let asNeeded: [MgoCoding]?
    public let doseQuantity: MgoQuantity?
    public let doseRange: MgoRange?
    public let maxDosePerPeriod: MgoRatio?
    public let rateQuantity: MgoQuantity?
    public let rateRange: MgoRange?
    public let rateRatio: MgoRatio?
    public let timing: DosageTiming

    public init(additionalInstruction: [[MgoCoding]]?, asNeeded: [MgoCoding]?, doseQuantity: MgoQuantity?, doseRange: MgoRange?, maxDosePerPeriod: MgoRatio?, rateQuantity: MgoQuantity?, rateRange: MgoRange?, rateRatio: MgoRatio?, timing: DosageTiming) {
        self.additionalInstruction = additionalInstruction
        self.asNeeded = asNeeded
        self.doseQuantity = doseQuantity
        self.doseRange = doseRange
        self.maxDosePerPeriod = maxDosePerPeriod
        self.rateQuantity = rateQuantity
        self.rateRange = rateRange
        self.rateRatio = rateRatio
        self.timing = timing
    }
}

// MARK: Dosage convenience initializers and mutators

public extension Dosage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Dosage.self, from: data)
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
        additionalInstruction: [[MgoCoding]]?? = nil,
        asNeeded: [MgoCoding]?? = nil,
        doseQuantity: MgoQuantity?? = nil,
        doseRange: MgoRange?? = nil,
        maxDosePerPeriod: MgoRatio?? = nil,
        rateQuantity: MgoQuantity?? = nil,
        rateRange: MgoRange?? = nil,
        rateRatio: MgoRatio?? = nil,
        timing: DosageTiming? = nil
    ) -> Dosage {
        return Dosage(
            additionalInstruction: additionalInstruction ?? self.additionalInstruction,
            asNeeded: asNeeded ?? self.asNeeded,
            doseQuantity: doseQuantity ?? self.doseQuantity,
            doseRange: doseRange ?? self.doseRange,
            maxDosePerPeriod: maxDosePerPeriod ?? self.maxDosePerPeriod,
            rateQuantity: rateQuantity ?? self.rateQuantity,
            rateRange: rateRange ?? self.rateRange,
            rateRatio: rateRatio ?? self.rateRatio,
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
