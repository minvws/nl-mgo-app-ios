// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibBloodPressureComponent = try ZibBloodPressureComponent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibBloodPressureComponent
public struct ZibBloodPressureComponent: Codable, Hashable, Sendable {
    public let averageBloodPressureLoinc: [AverageBloodPressureLoinc]?
    public let averageBloodPressureSnomed: [AverageBloodPressureSnomed]?
    public let cuffTypeLoinc: [CuffTypeLoinc]?
    public let cuffTypeSnomed: [CuffTypeSnomed]?
    public let diastolicBP: [DiastolicBP]?
    public let diastolicEndpoint: [DiastolicEndpoint]?
    public let positionLoinc: [PositionLoinc]?
    public let positionSnomed: [PositionSnomed]?
    public let systolicBP: [SystolicBP]?

    public init(averageBloodPressureLoinc: [AverageBloodPressureLoinc]?, averageBloodPressureSnomed: [AverageBloodPressureSnomed]?, cuffTypeLoinc: [CuffTypeLoinc]?, cuffTypeSnomed: [CuffTypeSnomed]?, diastolicBP: [DiastolicBP]?, diastolicEndpoint: [DiastolicEndpoint]?, positionLoinc: [PositionLoinc]?, positionSnomed: [PositionSnomed]?, systolicBP: [SystolicBP]?) {
        self.averageBloodPressureLoinc = averageBloodPressureLoinc
        self.averageBloodPressureSnomed = averageBloodPressureSnomed
        self.cuffTypeLoinc = cuffTypeLoinc
        self.cuffTypeSnomed = cuffTypeSnomed
        self.diastolicBP = diastolicBP
        self.diastolicEndpoint = diastolicEndpoint
        self.positionLoinc = positionLoinc
        self.positionSnomed = positionSnomed
        self.systolicBP = systolicBP
    }
}

// MARK: ZibBloodPressureComponent convenience initializers and mutators

public extension ZibBloodPressureComponent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibBloodPressureComponent.self, from: data)
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
        averageBloodPressureLoinc: [AverageBloodPressureLoinc]?? = nil,
        averageBloodPressureSnomed: [AverageBloodPressureSnomed]?? = nil,
        cuffTypeLoinc: [CuffTypeLoinc]?? = nil,
        cuffTypeSnomed: [CuffTypeSnomed]?? = nil,
        diastolicBP: [DiastolicBP]?? = nil,
        diastolicEndpoint: [DiastolicEndpoint]?? = nil,
        positionLoinc: [PositionLoinc]?? = nil,
        positionSnomed: [PositionSnomed]?? = nil,
        systolicBP: [SystolicBP]?? = nil
    ) -> ZibBloodPressureComponent {
        return ZibBloodPressureComponent(
            averageBloodPressureLoinc: averageBloodPressureLoinc ?? self.averageBloodPressureLoinc,
            averageBloodPressureSnomed: averageBloodPressureSnomed ?? self.averageBloodPressureSnomed,
            cuffTypeLoinc: cuffTypeLoinc ?? self.cuffTypeLoinc,
            cuffTypeSnomed: cuffTypeSnomed ?? self.cuffTypeSnomed,
            diastolicBP: diastolicBP ?? self.diastolicBP,
            diastolicEndpoint: diastolicEndpoint ?? self.diastolicEndpoint,
            positionLoinc: positionLoinc ?? self.positionLoinc,
            positionSnomed: positionSnomed ?? self.positionSnomed,
            systolicBP: systolicBP ?? self.systolicBP
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
