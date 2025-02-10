// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let repeat = try Repeat(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Repeat
public struct Repeat: Codable, Hashable, Sendable {
    public let boundsDuration: MgoDuration?
    public let boundsPeriod: MgoPeriod?
    public let boundsRange: MgoRange?
    public let dayOfWeek: [String]?
    public let duration: Double?
    public let durationUnit: String?
    public let frequency, frequencyMax, period: Double?
    public let periodUnit: String?
    public let timeOfDay, when: [String]?

    public init(boundsDuration: MgoDuration?, boundsPeriod: MgoPeriod?, boundsRange: MgoRange?, dayOfWeek: [String]?, duration: Double?, durationUnit: String?, frequency: Double?, frequencyMax: Double?, period: Double?, periodUnit: String?, timeOfDay: [String]?, when: [String]?) {
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

// MARK: Repeat convenience initializers and mutators

public extension Repeat {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Repeat.self, from: data)
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
        dayOfWeek: [String]?? = nil,
        duration: Double?? = nil,
        durationUnit: String?? = nil,
        frequency: Double?? = nil,
        frequencyMax: Double?? = nil,
        period: Double?? = nil,
        periodUnit: String?? = nil,
        timeOfDay: [String]?? = nil,
        when: [String]?? = nil
    ) -> Repeat {
        return Repeat(
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
