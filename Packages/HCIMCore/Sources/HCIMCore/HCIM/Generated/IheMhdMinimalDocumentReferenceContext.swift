// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let iheMhdMinimalDocumentReferenceContext = try IheMhdMinimalDocumentReferenceContext(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - IheMhdMinimalDocumentReferenceContext
public struct IheMhdMinimalDocumentReferenceContext: Codable, Hashable, Sendable {
    public let facilityType: MgoCodeableConcept?
    public let period: MgoPeriod?
    public let practiceSetting: MgoCodeableConcept?
    public let sourcePatientInfo: MgoReference?

    public init(facilityType: MgoCodeableConcept?, period: MgoPeriod?, practiceSetting: MgoCodeableConcept?, sourcePatientInfo: MgoReference?) {
        self.facilityType = facilityType
        self.period = period
        self.practiceSetting = practiceSetting
        self.sourcePatientInfo = sourcePatientInfo
    }
}

// MARK: IheMhdMinimalDocumentReferenceContext convenience initializers and mutators

public extension IheMhdMinimalDocumentReferenceContext {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IheMhdMinimalDocumentReferenceContext.self, from: data)
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
        facilityType: MgoCodeableConcept?? = nil,
        period: MgoPeriod?? = nil,
        practiceSetting: MgoCodeableConcept?? = nil,
        sourcePatientInfo: MgoReference?? = nil
    ) -> IheMhdMinimalDocumentReferenceContext {
        return IheMhdMinimalDocumentReferenceContext(
            facilityType: facilityType ?? self.facilityType,
            period: period ?? self.period,
            practiceSetting: practiceSetting ?? self.practiceSetting,
            sourcePatientInfo: sourcePatientInfo ?? self.sourcePatientInfo
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
