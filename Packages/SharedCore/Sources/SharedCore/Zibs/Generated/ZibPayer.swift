// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zibPayer = try ZibPayer(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibPayer
public struct ZibPayer: Codable, Hashable, Sendable {
    public let beneficiary: MgoReference?
    public let contract: [MgoReference]?
    public let dependent: String?
    public let fhirVersion: FhirVersionR3
    public let grouping: Grouping
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let network: String?
    public let order: Double?
    public let payor: [MgoReference]?
    public let period: MgoPeriod?
    public let policyHolder: MgoReference?
    public let profile: ZibPayerProfile
    public let referenceID: String
    public let relationship: MgoCodeableConcept?
    public let resourceType, sequence: String?
    public let status: ZibPayerStatus?
    public let subscriber: MgoReference?
    public let subscriberID: String?
    public let type: MgoCodeableConcept?

    public enum CodingKeys: String, CodingKey {
        case beneficiary, contract, dependent, fhirVersion, grouping, id, identifier, network, order, payor, period, policyHolder, profile
        case referenceID = "referenceId"
        case relationship, resourceType, sequence, status, subscriber
        case subscriberID = "subscriberId"
        case type
    }

    public init(beneficiary: MgoReference?, contract: [MgoReference]?, dependent: String?, fhirVersion: FhirVersionR3, grouping: Grouping, id: String?, identifier: [MgoIdentifier]?, network: String?, order: Double?, payor: [MgoReference]?, period: MgoPeriod?, policyHolder: MgoReference?, profile: ZibPayerProfile, referenceID: String, relationship: MgoCodeableConcept?, resourceType: String?, sequence: String?, status: ZibPayerStatus?, subscriber: MgoReference?, subscriberID: String?, type: MgoCodeableConcept?) {
        self.beneficiary = beneficiary
        self.contract = contract
        self.dependent = dependent
        self.fhirVersion = fhirVersion
        self.grouping = grouping
        self.id = id
        self.identifier = identifier
        self.network = network
        self.order = order
        self.payor = payor
        self.period = period
        self.policyHolder = policyHolder
        self.profile = profile
        self.referenceID = referenceID
        self.relationship = relationship
        self.resourceType = resourceType
        self.sequence = sequence
        self.status = status
        self.subscriber = subscriber
        self.subscriberID = subscriberID
        self.type = type
    }
}

// MARK: ZibPayer convenience initializers and mutators

public extension ZibPayer {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ZibPayer.self, from: data)
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
        beneficiary: MgoReference?? = nil,
        contract: [MgoReference]?? = nil,
        dependent: String?? = nil,
        fhirVersion: FhirVersionR3? = nil,
        grouping: Grouping? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        network: String?? = nil,
        order: Double?? = nil,
        payor: [MgoReference]?? = nil,
        period: MgoPeriod?? = nil,
        policyHolder: MgoReference?? = nil,
        profile: ZibPayerProfile? = nil,
        referenceID: String? = nil,
        relationship: MgoCodeableConcept?? = nil,
        resourceType: String?? = nil,
        sequence: String?? = nil,
        status: ZibPayerStatus?? = nil,
        subscriber: MgoReference?? = nil,
        subscriberID: String?? = nil,
        type: MgoCodeableConcept?? = nil
    ) -> ZibPayer {
        return ZibPayer(
            beneficiary: beneficiary ?? self.beneficiary,
            contract: contract ?? self.contract,
            dependent: dependent ?? self.dependent,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            grouping: grouping ?? self.grouping,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            network: network ?? self.network,
            order: order ?? self.order,
            payor: payor ?? self.payor,
            period: period ?? self.period,
            policyHolder: policyHolder ?? self.policyHolder,
            profile: profile ?? self.profile,
            referenceID: referenceID ?? self.referenceID,
            relationship: relationship ?? self.relationship,
            resourceType: resourceType ?? self.resourceType,
            sequence: sequence ?? self.sequence,
            status: status ?? self.status,
            subscriber: subscriber ?? self.subscriber,
            subscriberID: subscriberID ?? self.subscriberID,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
