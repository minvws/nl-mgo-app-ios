// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let downloadLink = try DownloadLink(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - DownloadLink
public struct DownloadLink: Codable, Hashable, Sendable {
    public let label: String
    public let type: DownloadLinkType
    public let url: String?

    public init(label: String, type: DownloadLinkType, url: String?) {
        self.label = label
        self.type = type
        self.url = url
    }
}

// MARK: DownloadLink convenience initializers and mutators

public extension DownloadLink {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DownloadLink.self, from: data)
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
        label: String? = nil,
        type: DownloadLinkType? = nil,
        url: String?? = nil
    ) -> DownloadLink {
        return DownloadLink(
            label: label ?? self.label,
            type: type ?? self.type,
            url: url ?? self.url
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
