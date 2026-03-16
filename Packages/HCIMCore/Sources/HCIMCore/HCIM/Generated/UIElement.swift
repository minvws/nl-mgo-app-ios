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
    public let id, label: String
    public let type: UIElementType
    public let value: UIElementValue?
    public let display, reference, url: String?

    public init(id: String, label: String, type: UIElementType, value: UIElementValue?, display: String?, reference: String?, url: String?) {
        self.id = id
        self.label = label
        self.type = type
        self.value = value
        self.display = display
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
        id: String? = nil,
        label: String? = nil,
        type: UIElementType? = nil,
        value: UIElementValue?? = nil,
        display: String?? = nil,
        reference: String?? = nil,
        url: String?? = nil
    ) -> UIElement {
        return UIElement(
            id: id ?? self.id,
            label: label ?? self.label,
            type: type ?? self.type,
            value: value ?? self.value,
            display: display ?? self.display,
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
