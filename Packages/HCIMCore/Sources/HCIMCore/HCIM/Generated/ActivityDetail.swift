// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let activityDetail = try ActivityDetail(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ActivityDetail
public struct ActivityDetail: Codable, Hashable, Sendable {
    public let category: MgoCodeableConcept?
    public let code, description: PrimitiveValueTypeOfStringString?
    public let performer: [MgoReference]?
    public let scheduledString: PrimitiveValueTypeOfStringString?

    public init(category: MgoCodeableConcept?, code: PrimitiveValueTypeOfStringString?, description: PrimitiveValueTypeOfStringString?, performer: [MgoReference]?, scheduledString: PrimitiveValueTypeOfStringString?) {
        self.category = category
        self.code = code
        self.description = description
        self.performer = performer
        self.scheduledString = scheduledString
    }
}

// MARK: ActivityDetail convenience initializers and mutators

public extension ActivityDetail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ActivityDetail.self, from: data)
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
        category: MgoCodeableConcept?? = nil,
        code: PrimitiveValueTypeOfStringString?? = nil,
        description: PrimitiveValueTypeOfStringString?? = nil,
        performer: [MgoReference]?? = nil,
        scheduledString: PrimitiveValueTypeOfStringString?? = nil
    ) -> ActivityDetail {
        return ActivityDetail(
            category: category ?? self.category,
            code: code ?? self.code,
            description: description ?? self.description,
            performer: performer ?? self.performer,
            scheduledString: scheduledString ?? self.scheduledString
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
