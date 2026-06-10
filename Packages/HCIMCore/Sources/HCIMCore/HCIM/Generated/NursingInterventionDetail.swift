// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nursingInterventionDetail = try NursingInterventionDetail(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NursingInterventionDetail
public struct NursingInterventionDetail: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let description: MgoString?
    public let goal: [MgoReference]?
    public let medicalDevice: [ExtensionValueOfMgoReference]
    public let performer, reasonReference: [MgoReference]?
    public let scheduledTiming: MgoTiming?

    public init(code: MgoCodeableConcept?, description: MgoString?, goal: [MgoReference]?, medicalDevice: [ExtensionValueOfMgoReference], performer: [MgoReference]?, reasonReference: [MgoReference]?, scheduledTiming: MgoTiming?) {
        self.code = code
        self.description = description
        self.goal = goal
        self.medicalDevice = medicalDevice
        self.performer = performer
        self.reasonReference = reasonReference
        self.scheduledTiming = scheduledTiming
    }
}

// MARK: NursingInterventionDetail convenience initializers and mutators

public extension NursingInterventionDetail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NursingInterventionDetail.self, from: data)
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
        code: MgoCodeableConcept?? = nil,
        description: MgoString?? = nil,
        goal: [MgoReference]?? = nil,
        medicalDevice: [ExtensionValueOfMgoReference]? = nil,
        performer: [MgoReference]?? = nil,
        reasonReference: [MgoReference]?? = nil,
        scheduledTiming: MgoTiming?? = nil
    ) -> NursingInterventionDetail {
        return NursingInterventionDetail(
            code: code ?? self.code,
            description: description ?? self.description,
            goal: goal ?? self.goal,
            medicalDevice: medicalDevice ?? self.medicalDevice,
            performer: performer ?? self.performer,
            reasonReference: reasonReference ?? self.reasonReference,
            scheduledTiming: scheduledTiming ?? self.scheduledTiming
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
