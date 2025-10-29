// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibFamilySituationComponent = try ZibFamilySituationComponent(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibFamilySituationComponent
public struct ZibFamilySituationComponent: Codable, Hashable, Sendable {
    public let careResponsibility: [CareResponsibility]?
    public let familyComposition: [FamilyComposition]?
    public let numberOfChildren: [NumberOfChild]?
    public let numberOfChildrenLivingAtHome: [NumberOfChildrenLivingAtHome]?

    public init(careResponsibility: [CareResponsibility]?, familyComposition: [FamilyComposition]?, numberOfChildren: [NumberOfChild]?, numberOfChildrenLivingAtHome: [NumberOfChildrenLivingAtHome]?) {
        self.careResponsibility = careResponsibility
        self.familyComposition = familyComposition
        self.numberOfChildren = numberOfChildren
        self.numberOfChildrenLivingAtHome = numberOfChildrenLivingAtHome
    }
}

// MARK: ZibFamilySituationComponent convenience initializers and mutators

public extension ZibFamilySituationComponent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibFamilySituationComponent.self, from: data)
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
        careResponsibility: [CareResponsibility]?? = nil,
        familyComposition: [FamilyComposition]?? = nil,
        numberOfChildren: [NumberOfChild]?? = nil,
        numberOfChildrenLivingAtHome: [NumberOfChildrenLivingAtHome]?? = nil
    ) -> ZibFamilySituationComponent {
        return ZibFamilySituationComponent(
            careResponsibility: careResponsibility ?? self.careResponsibility,
            familyComposition: familyComposition ?? self.familyComposition,
            numberOfChildren: numberOfChildren ?? self.numberOfChildren,
            numberOfChildrenLivingAtHome: numberOfChildrenLivingAtHome ?? self.numberOfChildrenLivingAtHome
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
