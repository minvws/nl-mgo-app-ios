// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uISchemaElement = try UISchemaElement(json)
//   let valueOptions = try ValueOptions(json)
//   let baseValueDescription = try BaseValueDescription(json)
//   let singleValue = try SingleValue(json)
//   let multipleValue = try MultipleValue(json)
//   let multipleGroupValue = try MultipleGroupValue(json)
//   let reference = try Reference(json)
//   let valueDescription = try ValueDescription(json)
//   let uISchemaGroup = try UISchemaGroup(json)
//   let uISchema = try UISchema(json)
//   let baseValueDescriptionT = try BaseValueDescriptionT(json)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - BaseValueDescriptionT
public struct BaseValueDescriptionT: Codable, Hashable, Sendable {
	public let display: [DisplayElement]?
	public let label: String
	public let summary: Bool?
	public let type: String

	public init(display: [DisplayElement]?, label: String, summary: Bool?, type: String) {
		self.display = display
		self.label = label
		self.summary = summary
		self.type = type
	}
}

// MARK: BaseValueDescriptionT convenience initializers and mutators

public extension BaseValueDescriptionT {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(BaseValueDescriptionT.self, from: data)
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
		summary: Bool?? = nil,
		type: String? = nil
	) -> BaseValueDescriptionT {
		return BaseValueDescriptionT(
			display: display ?? self.display,
			label: label ?? self.label,
			summary: summary ?? self.summary,
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

public enum DisplayElement: Codable, Hashable, Sendable {
	case string(String)
	case stringArray([String])

	public init(from decoder: Decoder) throws {
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

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let x):
			try container.encode(x)
		case .stringArray(let x):
			try container.encode(x)
		}
	}
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - MultipleGroupValue
public struct MultipleGroupValue: Codable, Hashable, Sendable {
	public let display: [[String]]?
	public let label: String
	public let summary: Bool?
	public let type: String

	public init(display: [[String]]?, label: String, summary: Bool?, type: String) {
		self.display = display
		self.label = label
		self.summary = summary
		self.type = type
	}
}

// MARK: MultipleGroupValue convenience initializers and mutators

public extension MultipleGroupValue {
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
		summary: Bool?? = nil,
		type: String? = nil
	) -> MultipleGroupValue {
		return MultipleGroupValue(
			display: display ?? self.display,
			label: label ?? self.label,
			summary: summary ?? self.summary,
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - MultipleValue
public struct MultipleValue: Codable, Hashable, Sendable {
	public let display: [String]?
	public let label: String
	public let summary: Bool?
	public let type: String

	public init(display: [String]?, label: String, summary: Bool?, type: String) {
		self.display = display
		self.label = label
		self.summary = summary
		self.type = type
	}
}

// MARK: MultipleValue convenience initializers and mutators

public extension MultipleValue {
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
		summary: Bool?? = nil,
		type: String? = nil
	) -> MultipleValue {
		return MultipleValue(
			display: display ?? self.display,
			label: label ?? self.label,
			summary: summary ?? self.summary,
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Reference
public struct Reference: Codable, Hashable, Sendable {
	public let display: String?
	public let label: String
	public let reference: String?
	public let summary: Bool?
	public let type: String

	public init(display: String?, label: String, reference: String?, summary: Bool?, type: String) {
		self.display = display
		self.label = label
		self.reference = reference
		self.summary = summary
		self.type = type
	}
}

// MARK: Reference convenience initializers and mutators

public extension Reference {
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
		summary: Bool?? = nil,
		type: String? = nil
	) -> Reference {
		return Reference(
			display: display ?? self.display,
			label: label ?? self.label,
			reference: reference ?? self.reference,
			summary: summary ?? self.summary,
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - SingleValue
public struct SingleValue: Codable, Hashable, Sendable {
	public let display: String?
	public let label: String
	public let summary: Bool?
	public let type: String

	public init(display: String?, label: String, summary: Bool?, type: String) {
		self.display = display
		self.label = label
		self.summary = summary
		self.type = type
	}
}

// MARK: SingleValue convenience initializers and mutators

public extension SingleValue {
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
		summary: Bool?? = nil,
		type: String? = nil
	) -> SingleValue {
		return SingleValue(
			display: display ?? self.display,
			label: label ?? self.label,
			summary: summary ?? self.summary,
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - UISchema
public struct UISchema: Codable, Hashable, Sendable {
	public let children: [UISchemaGroup]
	public let label: String

	public init(children: [UISchemaGroup], label: String) {
		self.children = children
		self.label = label
	}
}

// MARK: UISchema convenience initializers and mutators

public extension UISchema {
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - UISchemaGroup
public struct UISchemaGroup: Codable, Hashable, Sendable {
	public let children: [ValueDescription]
	public let label: String

	public init(children: [ValueDescription], label: String) {
		self.children = children
		self.label = label
	}
}

// MARK: UISchemaGroup convenience initializers and mutators

public extension UISchemaGroup {
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
		children: [ValueDescription]? = nil,
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ValueDescription
public struct ValueDescription: Codable, Hashable, Sendable {
	public let display: ValueDescriptionDisplay
	public let label: String
	public let summary: Bool?
	public let type: String
	public let reference: String?

	public init(display: ValueDescriptionDisplay, label: String, summary: Bool?, type: String, reference: String?) {
		self.display = display
		self.label = label
		self.summary = summary
		self.type = type
		self.reference = reference
	}
}

// MARK: ValueDescription convenience initializers and mutators

public extension ValueDescription {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ValueDescription.self, from: data)
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
		display: ValueDescriptionDisplay? = nil,
		label: String? = nil,
		summary: Bool?? = nil,
		type: String? = nil,
		reference: String?? = nil
	) -> ValueDescription {
		return ValueDescription(
			display: display ?? self.display,
			label: label ?? self.label,
			summary: summary ?? self.summary,
			type: type ?? self.type,
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

public enum ValueDescriptionDisplay: Codable, Hashable, Sendable {
	case string(String)
	case unionArray([DisplayElement])
	case null

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let x = try? container.decode([DisplayElement].self) {
			self = .unionArray(x)
			return
		}
		if let x = try? container.decode(String.self) {
			self = .string(x)
			return
		}
		if container.decodeNil() {
			self = .null
			return
		}
		throw DecodingError.typeMismatch(ValueDescriptionDisplay.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueDescriptionDisplay"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let x):
			try container.encode(x)
		case .unionArray(let x):
			try container.encode(x)
		case .null:
			try container.encodeNil()
		}
	}
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - UISchemaElement
public struct UISchemaElement: Codable, Hashable, Sendable {
	public let label: String

	public init(label: String) {
		self.label = label
	}
}

// MARK: UISchemaElement convenience initializers and mutators

public extension UISchemaElement {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(UISchemaElement.self, from: data)
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
	) -> UISchemaElement {
		return UISchemaElement(
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ValueOptions
public struct ValueOptions: Codable, Hashable, Sendable {
	public let summary: Bool?

	public init(summary: Bool?) {
		self.summary = summary
	}
}

// MARK: ValueOptions convenience initializers and mutators

public extension ValueOptions {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ValueOptions.self, from: data)
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
		summary: Bool?? = nil
	) -> ValueOptions {
		return ValueOptions(
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
