// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibAdministrationScheduleRepeat = try ZibAdministrationScheduleRepeat(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibAdministrationScheduleRepeat
public struct ZibAdministrationScheduleRepeat: Codable, Hashable, Sendable {
    public let boundsDuration: MgoDuration?
    public let boundsPeriod: MgoPeriod?
    public let boundsRange: MgoRange?
    public let dayOfWeek: [MgoCode]?
    public let duration: MgoDecimal?
    public let durationUnit: MgoCode?
    public let frequency, frequencyMax: MgoInteger?
    public let period: MgoDecimal?
    public let periodUnit: MgoCode?
    public let timeOfDay: [MgoDateTime]?
    public let when: [MgoCode]?

    public init(boundsDuration: MgoDuration?, boundsPeriod: MgoPeriod?, boundsRange: MgoRange?, dayOfWeek: [MgoCode]?, duration: MgoDecimal?, durationUnit: MgoCode?, frequency: MgoInteger?, frequencyMax: MgoInteger?, period: MgoDecimal?, periodUnit: MgoCode?, timeOfDay: [MgoDateTime]?, when: [MgoCode]?) {
        self.boundsDuration = boundsDuration
        self.boundsPeriod = boundsPeriod
        self.boundsRange = boundsRange
        self.dayOfWeek = dayOfWeek
        self.duration = duration
        self.durationUnit = durationUnit
        self.frequency = frequency
        self.frequencyMax = frequencyMax
        self.period = period
        self.periodUnit = periodUnit
        self.timeOfDay = timeOfDay
        self.when = when
    }
}

// MARK: ZibAdministrationScheduleRepeat convenience initializers and mutators

public extension ZibAdministrationScheduleRepeat {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibAdministrationScheduleRepeat.self, from: data)
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
        dayOfWeek: [MgoCode]?? = nil,
        duration: MgoDecimal?? = nil,
        durationUnit: MgoCode?? = nil,
        frequency: MgoInteger?? = nil,
        frequencyMax: MgoInteger?? = nil,
        period: MgoDecimal?? = nil,
        periodUnit: MgoCode?? = nil,
        timeOfDay: [MgoDateTime]?? = nil,
        when: [MgoCode]?? = nil
    ) -> ZibAdministrationScheduleRepeat {
        return ZibAdministrationScheduleRepeat(
            boundsDuration: boundsDuration ?? self.boundsDuration,
            boundsPeriod: boundsPeriod ?? self.boundsPeriod,
            boundsRange: boundsRange ?? self.boundsRange,
            dayOfWeek: dayOfWeek ?? self.dayOfWeek,
            duration: duration ?? self.duration,
            durationUnit: durationUnit ?? self.durationUnit,
            frequency: frequency ?? self.frequency,
            frequencyMax: frequencyMax ?? self.frequencyMax,
            period: period ?? self.period,
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
