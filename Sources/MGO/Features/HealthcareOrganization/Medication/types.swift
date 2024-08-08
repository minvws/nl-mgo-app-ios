// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let element = try Element(json)
//   let value = try Value(json)
//   let singleValue = try SingleValue(json)
//   let multipleValue = try MultipleValue(json)
//   let multipleGroupValue = try MultipleGroupValue(json)
//   let reference = try Reference(json)
//   let groupChild = try GroupChild(json)
//   let uISchemaGroup = try UISchemaGroup(json)
//   let uISchema = try UISchema(json)
//   let valueT = try ValueT(json)

import Foundation

// MARK: - Element
struct Element: Codable {
    let label: String
}

// MARK: Element convenience initializers and mutators

extension Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Element.self, from: data)
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
        label: String? = nil
    ) -> Element {
        return Element(
            label: label ?? self.label
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ValueT
struct ValueT: Codable {
    let display: [DisplayElement]?
    let label: String
    let summary: Bool?
}

// MARK: ValueT convenience initializers and mutators

extension ValueT {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ValueT.self, from: data)
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
        display: [DisplayElement]?? = nil,
        label: String? = nil,
        summary: Bool?? = nil
    ) -> ValueT {
        return ValueT(
            display: display ?? self.display,
            label: label ?? self.label,
            summary: summary ?? self.summary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum DisplayElement: Codable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(DisplayElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DisplayElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - SingleValue
struct SingleValue: Codable {
    let display: String?
    let label: String
    let summary: Bool?
}

// MARK: SingleValue convenience initializers and mutators

extension SingleValue {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SingleValue.self, from: data)
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
        summary: Bool?? = nil
    ) -> SingleValue {
        return SingleValue(
            display: display ?? self.display,
            label: label ?? self.label,
            summary: summary ?? self.summary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - MultipleValue
struct MultipleValue: Codable {
    let display: [String]?
    let label: String
    let summary: Bool?
}

// MARK: MultipleValue convenience initializers and mutators

extension MultipleValue {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MultipleValue.self, from: data)
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
        display: [String]?? = nil,
        label: String? = nil,
        summary: Bool?? = nil
    ) -> MultipleValue {
        return MultipleValue(
            display: display ?? self.display,
            label: label ?? self.label,
            summary: summary ?? self.summary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - MultipleGroupValue
struct MultipleGroupValue: Codable {
    let display: [[String]]?
    let label: String
    let summary: Bool?
}

// MARK: MultipleGroupValue convenience initializers and mutators

extension MultipleGroupValue {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MultipleGroupValue.self, from: data)
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
        display: [[String]]?? = nil,
        label: String? = nil,
        summary: Bool?? = nil
    ) -> MultipleGroupValue {
        return MultipleGroupValue(
            display: display ?? self.display,
            label: label ?? self.label,
            summary: summary ?? self.summary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Reference
struct Reference: Codable {
    let display: String?
    let label: String
    let reference: String?
    let summary: Bool?
}

// MARK: Reference convenience initializers and mutators

extension Reference {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Reference.self, from: data)
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
        reference: String?? = nil,
        summary: Bool?? = nil
    ) -> Reference {
        return Reference(
            display: display ?? self.display,
            label: label ?? self.label,
            reference: reference ?? self.reference,
            summary: summary ?? self.summary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - UISchema
struct UISchema: Codable {
    let children: [UISchemaGroup]
    let label: String
}

// MARK: UISchema convenience initializers and mutators

extension UISchema {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UISchema.self, from: data)
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
        children: [UISchemaGroup]? = nil,
        label: String? = nil
    ) -> UISchema {
        return UISchema(
            children: children ?? self.children,
            label: label ?? self.label
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - UISchemaGroup
struct UISchemaGroup: Codable {
    let children: [GroupChild]
    let label: String
}

// MARK: UISchemaGroup convenience initializers and mutators

extension UISchemaGroup {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UISchemaGroup.self, from: data)
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
        children: [GroupChild]? = nil,
        label: String? = nil
    ) -> UISchemaGroup {
        return UISchemaGroup(
            children: children ?? self.children,
            label: label ?? self.label
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - GroupChild
struct GroupChild: Codable {
    let display: GroupChildDisplay?
    let label: String
    let summary: Bool?
    let reference: String?
}

// MARK: GroupChild convenience initializers and mutators

extension GroupChild {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GroupChild.self, from: data)
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
        display: GroupChildDisplay?? = nil,
        label: String? = nil,
        summary: Bool?? = nil,
        reference: String?? = nil
    ) -> GroupChild {
        return GroupChild(
            display: display ?? self.display,
            label: label ?? self.label,
            summary: summary ?? self.summary,
            reference: reference ?? self.reference
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum GroupChildDisplay: Codable {
    case string(String)
    case unionArray([DisplayElement])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([DisplayElement].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(GroupChildDisplay.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for GroupChildDisplay"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
