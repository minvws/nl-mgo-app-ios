// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uIElement = try UIElement(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - UIElement
public struct UIElement: Codable, Hashable, Sendable {
    public let display: UIElementDisplay?
    public let label: String
    public let type: UIElementType
    public let reference, url: String?

    public init(display: UIElementDisplay?, label: String, type: UIElementType, reference: String?, url: String?) {
        self.display = display
        self.label = label
        self.type = type
        self.reference = reference
        self.url = url
    }
}

// MARK: UIElement convenience initializers and mutators

public extension UIElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UIElement.self, from: data)
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
        display: UIElementDisplay?? = nil,
        label: String? = nil,
        type: UIElementType? = nil,
        reference: String?? = nil,
        url: String?? = nil
    ) -> UIElement {
        return UIElement(
            display: display ?? self.display,
            label: label ?? self.label,
            type: type ?? self.type,
            reference: reference ?? self.reference,
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
