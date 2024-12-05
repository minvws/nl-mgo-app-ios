// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uIEntryValueSINGLEVALUEString = try UIEntryValueSINGLEVALUEString(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - UIEntryValueSINGLEVALUEString
public struct UIEntryValueSINGLEVALUEString: Codable, Hashable, Sendable {
    public let display: String?
    public let label: String
    public let showEmpty: Bool?
    public let type: SingleValueType

    public init(display: String?, label: String, showEmpty: Bool?, type: SingleValueType) {
        self.display = display
        self.label = label
        self.showEmpty = showEmpty
        self.type = type
    }
}

// MARK: UIEntryValueSINGLEVALUEString convenience initializers and mutators

public extension UIEntryValueSINGLEVALUEString {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UIEntryValueSINGLEVALUEString.self, from: data)
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
        display: String?? = nil,
        label: String? = nil,
        showEmpty: Bool?? = nil,
        type: SingleValueType? = nil
    ) -> UIEntryValueSINGLEVALUEString {
        return UIEntryValueSINGLEVALUEString(
            display: display ?? self.display,
            label: label ?? self.label,
            showEmpty: showEmpty ?? self.showEmpty,
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
