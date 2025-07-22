// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mgoTimingRepeat = try MgoTimingRepeat(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - MgoTimingRepeat
public struct MgoTimingRepeat: Codable, Hashable, Sendable {
    public let boundsDuration: MgoDuration?
    public let boundsPeriod: MgoPeriod?
    public let boundsRange: MgoRange?
    public let count, countMax: MgoInteger?
    public let dayOfWeek: [MgoString]?
    public let duration, durationMax: MgoDecimal?
    public let durationUnit: MgoString?
    public let frequency, frequencyMax: MgoInteger?
    public let offset: MgoUnsignedInt?
    public let period, periodMax: MgoDecimal?
    public let periodUnit: MgoString?
    public let timeOfDay, when: [MgoString]?

    public init(boundsDuration: MgoDuration?, boundsPeriod: MgoPeriod?, boundsRange: MgoRange?, count: MgoInteger?, countMax: MgoInteger?, dayOfWeek: [MgoString]?, duration: MgoDecimal?, durationMax: MgoDecimal?, durationUnit: MgoString?, frequency: MgoInteger?, frequencyMax: MgoInteger?, offset: MgoUnsignedInt?, period: MgoDecimal?, periodMax: MgoDecimal?, periodUnit: MgoString?, timeOfDay: [MgoString]?, when: [MgoString]?) {
        self.boundsDuration = boundsDuration
        self.boundsPeriod = boundsPeriod
        self.boundsRange = boundsRange
        self.count = count
        self.countMax = countMax
        self.dayOfWeek = dayOfWeek
        self.duration = duration
        self.durationMax = durationMax
        self.durationUnit = durationUnit
        self.frequency = frequency
        self.frequencyMax = frequencyMax
        self.offset = offset
        self.period = period
        self.periodMax = periodMax
        self.periodUnit = periodUnit
        self.timeOfDay = timeOfDay
        self.when = when
    }
}

// MARK: MgoTimingRepeat convenience initializers and mutators

public extension MgoTimingRepeat {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MgoTimingRepeat.self, from: data)
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
        boundsDuration: MgoDuration?? = nil,
        boundsPeriod: MgoPeriod?? = nil,
        boundsRange: MgoRange?? = nil,
        count: MgoInteger?? = nil,
        countMax: MgoInteger?? = nil,
        dayOfWeek: [MgoString]?? = nil,
        duration: MgoDecimal?? = nil,
        durationMax: MgoDecimal?? = nil,
        durationUnit: MgoString?? = nil,
        frequency: MgoInteger?? = nil,
        frequencyMax: MgoInteger?? = nil,
        offset: MgoUnsignedInt?? = nil,
        period: MgoDecimal?? = nil,
        periodMax: MgoDecimal?? = nil,
        periodUnit: MgoString?? = nil,
        timeOfDay: [MgoString]?? = nil,
        when: [MgoString]?? = nil
    ) -> MgoTimingRepeat {
        return MgoTimingRepeat(
            boundsDuration: boundsDuration ?? self.boundsDuration,
            boundsPeriod: boundsPeriod ?? self.boundsPeriod,
            boundsRange: boundsRange ?? self.boundsRange,
            count: count ?? self.count,
            countMax: countMax ?? self.countMax,
            dayOfWeek: dayOfWeek ?? self.dayOfWeek,
            duration: duration ?? self.duration,
            durationMax: durationMax ?? self.durationMax,
            durationUnit: durationUnit ?? self.durationUnit,
            frequency: frequency ?? self.frequency,
            frequencyMax: frequencyMax ?? self.frequencyMax,
            offset: offset ?? self.offset,
            period: period ?? self.period,
            periodMax: periodMax ?? self.periodMax,
            periodUnit: periodUnit ?? self.periodUnit,
            timeOfDay: timeOfDay ?? self.timeOfDay,
            when: when ?? self.when
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
