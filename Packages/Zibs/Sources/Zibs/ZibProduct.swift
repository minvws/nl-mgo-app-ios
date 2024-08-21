// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dateTimeString = try DateTimeString(json)
//   let nictizNlProfile = try NictizNlProfile(json)
//   let zibMedicationUse = try ZibMedicationUse(json)
//   let zibProduct = try ZibProduct(json)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibProduct
public struct ZibProduct: Codable, Hashable, Sendable {
	public let profile: String
	public let code: [Code]?
	public let description: String?
	public let form: [Form]?
	public let id: String?
	public let ingredient: [Ingredient]?
	public let package: Package
	public let resourceType: String?

	public enum CodingKeys: String, CodingKey {
		case profile = "_profile"
		case code, description, form, id, ingredient, package, resourceType
	}

	public init(profile: String, code: [Code]?, description: String?, form: [Form]?, id: String?, ingredient: [Ingredient]?, package: Package, resourceType: String?) {
		self.profile = profile
		self.code = code
		self.description = description
		self.form = form
		self.id = id
		self.ingredient = ingredient
		self.package = package
		self.resourceType = resourceType
	}
}

// MARK: ZibProduct convenience initializers and mutators

public extension ZibProduct {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ZibProduct.self, from: data)
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
		profile: String? = nil,
		code: [Code]?? = nil,
		description: String?? = nil,
		form: [Form]?? = nil,
		id: String?? = nil,
		ingredient: [Ingredient]?? = nil,
		package: Package? = nil,
		resourceType: String?? = nil
	) -> ZibProduct {
		return ZibProduct(
			profile: profile ?? self.profile,
			code: code ?? self.code,
			description: description ?? self.description,
			form: form ?? self.form,
			id: id ?? self.id,
			ingredient: ingredient ?? self.ingredient,
			package: package ?? self.package,
			resourceType: resourceType ?? self.resourceType
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

// MARK: - Code
public struct Code: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: Code convenience initializers and mutators

public extension Code {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Code.self, from: data)
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
		code: String?? = nil,
		display: String?? = nil,
		system: String?? = nil
	) -> Code {
		return Code(
			code: code ?? self.code,
			display: display ?? self.display,
			system: system ?? self.system
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

// MARK: - Form
public struct Form: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: Form convenience initializers and mutators

public extension Form {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Form.self, from: data)
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
		code: String?? = nil,
		display: String?? = nil,
		system: String?? = nil
	) -> Form {
		return Form(
			code: code ?? self.code,
			display: display ?? self.display,
			system: system ?? self.system
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

// MARK: - Ingredient
public struct Ingredient: Codable, Hashable, Sendable {
	public let amount: Amount?
	public let item: [PurpleItem]?

	public init(amount: Amount?, item: [PurpleItem]?) {
		self.amount = amount
		self.item = item
	}
}

// MARK: Ingredient convenience initializers and mutators

public extension Ingredient {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Ingredient.self, from: data)
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
		amount: Amount?? = nil,
		item: [PurpleItem]?? = nil
	) -> Ingredient {
		return Ingredient(
			amount: amount ?? self.amount,
			item: item ?? self.item
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

// MARK: - Amount
public struct Amount: Codable, Hashable, Sendable {
	public let denominator: TentacledDenominator?
	public let numerator: TentacledNumerator?

	public init(denominator: TentacledDenominator?, numerator: TentacledNumerator?) {
		self.denominator = denominator
		self.numerator = numerator
	}
}

// MARK: Amount convenience initializers and mutators

public extension Amount {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Amount.self, from: data)
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
		denominator: TentacledDenominator?? = nil,
		numerator: TentacledNumerator?? = nil
	) -> Amount {
		return Amount(
			denominator: denominator ?? self.denominator,
			numerator: numerator ?? self.numerator
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

// MARK: - TentacledDenominator
public struct TentacledDenominator: Codable, Hashable, Sendable {
	public let code: String?
	public let comparator: Comparator?
	public let system, unit: String?
	public let value: Double?

	public init(code: String?, comparator: Comparator?, system: String?, unit: String?, value: Double?) {
		self.code = code
		self.comparator = comparator
		self.system = system
		self.unit = unit
		self.value = value
	}
}

// MARK: TentacledDenominator convenience initializers and mutators

public extension TentacledDenominator {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(TentacledDenominator.self, from: data)
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
		code: String?? = nil,
		comparator: Comparator?? = nil,
		system: String?? = nil,
		unit: String?? = nil,
		value: Double?? = nil
	) -> TentacledDenominator {
		return TentacledDenominator(
			code: code ?? self.code,
			comparator: comparator ?? self.comparator,
			system: system ?? self.system,
			unit: unit ?? self.unit,
			value: value ?? self.value
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

// MARK: - TentacledNumerator
public struct TentacledNumerator: Codable, Hashable, Sendable {
	public let code: String?
	public let comparator: Comparator?
	public let system, unit: String?
	public let value: Double?

	public init(code: String?, comparator: Comparator?, system: String?, unit: String?, value: Double?) {
		self.code = code
		self.comparator = comparator
		self.system = system
		self.unit = unit
		self.value = value
	}
}

// MARK: TentacledNumerator convenience initializers and mutators

public extension TentacledNumerator {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(TentacledNumerator.self, from: data)
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
		code: String?? = nil,
		comparator: Comparator?? = nil,
		system: String?? = nil,
		unit: String?? = nil,
		value: Double?? = nil
	) -> TentacledNumerator {
		return TentacledNumerator(
			code: code ?? self.code,
			comparator: comparator ?? self.comparator,
			system: system ?? self.system,
			unit: unit ?? self.unit,
			value: value ?? self.value
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

// MARK: - PurpleItem
public struct PurpleItem: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: PurpleItem convenience initializers and mutators

public extension PurpleItem {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleItem.self, from: data)
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
		code: String?? = nil,
		display: String?? = nil,
		system: String?? = nil
	) -> PurpleItem {
		return PurpleItem(
			code: code ?? self.code,
			display: display ?? self.display,
			system: system ?? self.system
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

// MARK: - Package
public struct Package: Codable, Hashable, Sendable {
	public let content: [Content]?

	public init(content: [Content]?) {
		self.content = content
	}
}

// MARK: Package convenience initializers and mutators

public extension Package {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Package.self, from: data)
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
		content: [Content]?? = nil
	) -> Package {
		return Package(
			content: content ?? self.content
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

// MARK: - Content
public struct Content: Codable, Hashable, Sendable {
	public let item: [FluffyItem]?
	public let reference: ReferenceClass?

	public init(item: [FluffyItem]?, reference: ReferenceClass?) {
		self.item = item
		self.reference = reference
	}
}

// MARK: Content convenience initializers and mutators

public extension Content {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Content.self, from: data)
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
		item: [FluffyItem]?? = nil,
		reference: ReferenceClass?? = nil
	) -> Content {
		return Content(
			item: item ?? self.item,
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - FluffyItem
public struct FluffyItem: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: FluffyItem convenience initializers and mutators

public extension FluffyItem {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyItem.self, from: data)
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
		code: String?? = nil,
		display: String?? = nil,
		system: String?? = nil
	) -> FluffyItem {
		return FluffyItem(
			code: code ?? self.code,
			display: display ?? self.display,
			system: system ?? self.system
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

// MARK: - ReferenceClass
public struct ReferenceClass: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: ReferenceClass convenience initializers and mutators

public extension ReferenceClass {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ReferenceClass.self, from: data)
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
		reference: String?? = nil
	) -> ReferenceClass {
		return ReferenceClass(
			display: display ?? self.display,
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
