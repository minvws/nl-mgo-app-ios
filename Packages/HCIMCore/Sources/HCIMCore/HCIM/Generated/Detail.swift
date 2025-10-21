// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let detail = try Detail(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Detail
public struct Detail: Codable, Hashable, Sendable {
    public let code: MgoCodeableConcept?
    public let description: PrimitiveValueTypeOfStringString?
    public let goal: [MgoReference]?
    public let medicalDevice: [ExtensionValueOfMgoReference]
    public let performer, reasonReference: [MgoReference]?
    public let scheduledTiming: MgoTiming?

    public init(code: MgoCodeableConcept?, description: PrimitiveValueTypeOfStringString?, goal: [MgoReference]?, medicalDevice: [ExtensionValueOfMgoReference], performer: [MgoReference]?, reasonReference: [MgoReference]?, scheduledTiming: MgoTiming?) {
        self.code = code
        self.description = description
        self.goal = goal
        self.medicalDevice = medicalDevice
        self.performer = performer
        self.reasonReference = reasonReference
        self.scheduledTiming = scheduledTiming
    }
}

// MARK: Detail convenience initializers and mutators

public extension Detail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Detail.self, from: data)
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
        description: PrimitiveValueTypeOfStringString?? = nil,
        goal: [MgoReference]?? = nil,
        medicalDevice: [ExtensionValueOfMgoReference]? = nil,
        performer: [MgoReference]?? = nil,
        reasonReference: [MgoReference]?? = nil,
        scheduledTiming: MgoTiming?? = nil
    ) -> Detail {
        return Detail(
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
