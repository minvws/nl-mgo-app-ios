// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let grouping = try Grouping(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Grouping
public struct Grouping: Codable, Hashable, Sendable {
    public let groupingClass, classDisplay, group, groupDisplay: String?
    public let plan, planDisplay, subClass, subClassDisplay: String?
    public let subGroup, subGroupDisplay, subPlan, subPlanDisplay: String?

    public enum CodingKeys: String, CodingKey {
        case groupingClass = "class"
        case classDisplay, group, groupDisplay, plan, planDisplay, subClass, subClassDisplay, subGroup, subGroupDisplay, subPlan, subPlanDisplay
    }

    public init(groupingClass: String?, classDisplay: String?, group: String?, groupDisplay: String?, plan: String?, planDisplay: String?, subClass: String?, subClassDisplay: String?, subGroup: String?, subGroupDisplay: String?, subPlan: String?, subPlanDisplay: String?) {
        self.groupingClass = groupingClass
        self.classDisplay = classDisplay
        self.group = group
        self.groupDisplay = groupDisplay
        self.plan = plan
        self.planDisplay = planDisplay
        self.subClass = subClass
        self.subClassDisplay = subClassDisplay
        self.subGroup = subGroup
        self.subGroupDisplay = subGroupDisplay
        self.subPlan = subPlan
        self.subPlanDisplay = subPlanDisplay
    }
}

// MARK: Grouping convenience initializers and mutators

public extension Grouping {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Grouping.self, from: data)
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
        groupingClass: String?? = nil,
        classDisplay: String?? = nil,
        group: String?? = nil,
        groupDisplay: String?? = nil,
        plan: String?? = nil,
        planDisplay: String?? = nil,
        subClass: String?? = nil,
        subClassDisplay: String?? = nil,
        subGroup: String?? = nil,
        subGroupDisplay: String?? = nil,
        subPlan: String?? = nil,
        subPlanDisplay: String?? = nil
    ) -> Grouping {
        return Grouping(
            groupingClass: groupingClass ?? self.groupingClass,
            classDisplay: classDisplay ?? self.classDisplay,
            group: group ?? self.group,
            groupDisplay: groupDisplay ?? self.groupDisplay,
            plan: plan ?? self.plan,
            planDisplay: planDisplay ?? self.planDisplay,
            subClass: subClass ?? self.subClass,
            subClassDisplay: subClassDisplay ?? self.subClassDisplay,
            subGroup: subGroup ?? self.subGroup,
            subGroupDisplay: subGroupDisplay ?? self.subGroupDisplay,
            subPlan: subPlan ?? self.subPlan,
            subPlanDisplay: subPlanDisplay ?? self.subPlanDisplay
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
