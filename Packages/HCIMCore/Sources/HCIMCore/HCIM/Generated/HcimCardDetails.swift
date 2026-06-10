// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hcimCardDetails = try HcimCardDetails(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - HcimCardDetails
public struct HcimCardDetails: Codable, Hashable, Sendable {
    public let description, descriptionIcon, detail: String?
    public let title: String

    public init(description: String?, descriptionIcon: String?, detail: String?, title: String) {
        self.description = description
        self.descriptionIcon = descriptionIcon
        self.detail = detail
        self.title = title
    }
}

// MARK: HcimCardDetails convenience initializers and mutators

public extension HcimCardDetails {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(HcimCardDetails.self, from: data)
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
        description: String?? = nil,
        descriptionIcon: String?? = nil,
        detail: String?? = nil,
        title: String? = nil
    ) -> HcimCardDetails {
        return HcimCardDetails(
            description: description ?? self.description,
            descriptionIcon: descriptionIcon ?? self.descriptionIcon,
            detail: detail ?? self.detail,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
