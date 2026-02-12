// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let organization = try Organization(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Organization
public struct Organization: Codable, Hashable, Sendable {
    public let addressLine, careTypeDisplay, city: String?
    public let dataServices: [String: DataService]?
    public let displayName: String?
    public let geoLat, geoLng: Double?
    public let id: String
    public let normalizedDisplayName, postalCode, searchBlob: String?

    public init(addressLine: String?, careTypeDisplay: String?, city: String?, dataServices: [String: DataService]?, displayName: String?, geoLat: Double?, geoLng: Double?, id: String, normalizedDisplayName: String?, postalCode: String?, searchBlob: String?) {
        self.addressLine = addressLine
        self.careTypeDisplay = careTypeDisplay
        self.city = city
        self.dataServices = dataServices
        self.displayName = displayName
        self.geoLat = geoLat
        self.geoLng = geoLng
        self.id = id
        self.normalizedDisplayName = normalizedDisplayName
        self.postalCode = postalCode
        self.searchBlob = searchBlob
    }
}

// MARK: Organization convenience initializers and mutators

public extension Organization {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Organization.self, from: data)
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
        addressLine: String?? = nil,
        careTypeDisplay: String?? = nil,
        city: String?? = nil,
        dataServices: [String: DataService]?? = nil,
        displayName: String?? = nil,
        geoLat: Double?? = nil,
        geoLng: Double?? = nil,
        id: String? = nil,
        normalizedDisplayName: String?? = nil,
        postalCode: String?? = nil,
        searchBlob: String?? = nil
    ) -> Organization {
        return Organization(
            addressLine: addressLine ?? self.addressLine,
            careTypeDisplay: careTypeDisplay ?? self.careTypeDisplay,
            city: city ?? self.city,
            dataServices: dataServices ?? self.dataServices,
            displayName: displayName ?? self.displayName,
            geoLat: geoLat ?? self.geoLat,
            geoLng: geoLng ?? self.geoLng,
            id: id ?? self.id,
            normalizedDisplayName: normalizedDisplayName ?? self.normalizedDisplayName,
            postalCode: postalCode ?? self.postalCode,
            searchBlob: searchBlob ?? self.searchBlob
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
