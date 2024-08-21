// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dateTimeString = try DateTimeString(json)
//   let nictizNlProfile = try NictizNlProfile(json)
//   let zibMedicationUse = try ZibMedicationUse(json)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ZibMedicationUse
public struct ZibMedicationUse: Codable, Hashable, Sendable {
	public let profile: String
	public let asAgreedIndicator: Bool?
	public let author: PurpleAuthor?
	public let category: [Category]?
	public let dateAsserted: String?
	public let dosage: [Dosage]?
	public let effectiveDuration: EffectiveDuration?
	public let effectivePeriod: EffectivePeriod?
	public let id: String?
	public let identifier: [Identifier]?
	public let informationSource: InformationSource?
	public let medication: Medication?
	public let medicationTreatment: MedicationTreatment?
	public let note: [Note]?
	public let prescriber: Prescriber?
	public let reasonCode: [[ReasonCode]]?
	public let reasonForChangeOrDiscontinuationOfUse: [ReasonForChangeOrDiscontinuationOfUse]?
	public let repeatPeriodCyclicalSchedule: RepeatPeriodCyclicalSchedule?
	public let resourceType, status: String?
	public let subject: Subject?
	public let taken: String?

	public enum CodingKeys: String, CodingKey {
		case profile = "_profile"
		case asAgreedIndicator, author, category, dateAsserted, dosage, effectiveDuration, effectivePeriod, id, identifier, informationSource, medication, medicationTreatment, note, prescriber, reasonCode, reasonForChangeOrDiscontinuationOfUse, repeatPeriodCyclicalSchedule, resourceType, status, subject, taken
	}

	public init(profile: String, asAgreedIndicator: Bool?, author: PurpleAuthor?, category: [Category]?, dateAsserted: String?, dosage: [Dosage]?, effectiveDuration: EffectiveDuration?, effectivePeriod: EffectivePeriod?, id: String?, identifier: [Identifier]?, informationSource: InformationSource?, medication: Medication?, medicationTreatment: MedicationTreatment?, note: [Note]?, prescriber: Prescriber?, reasonCode: [[ReasonCode]]?, reasonForChangeOrDiscontinuationOfUse: [ReasonForChangeOrDiscontinuationOfUse]?, repeatPeriodCyclicalSchedule: RepeatPeriodCyclicalSchedule?, resourceType: String?, status: String?, subject: Subject?, taken: String?) {
		self.profile = profile
		self.asAgreedIndicator = asAgreedIndicator
		self.author = author
		self.category = category
		self.dateAsserted = dateAsserted
		self.dosage = dosage
		self.effectiveDuration = effectiveDuration
		self.effectivePeriod = effectivePeriod
		self.id = id
		self.identifier = identifier
		self.informationSource = informationSource
		self.medication = medication
		self.medicationTreatment = medicationTreatment
		self.note = note
		self.prescriber = prescriber
		self.reasonCode = reasonCode
		self.reasonForChangeOrDiscontinuationOfUse = reasonForChangeOrDiscontinuationOfUse
		self.repeatPeriodCyclicalSchedule = repeatPeriodCyclicalSchedule
		self.resourceType = resourceType
		self.status = status
		self.subject = subject
		self.taken = taken
	}
}

// MARK: ZibMedicationUse convenience initializers and mutators

public extension ZibMedicationUse {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ZibMedicationUse.self, from: data)
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
		asAgreedIndicator: Bool?? = nil,
		author: PurpleAuthor?? = nil,
		category: [Category]?? = nil,
		dateAsserted: String? = nil,
		dosage: [Dosage]?? = nil,
		effectiveDuration: EffectiveDuration?? = nil,
		effectivePeriod: EffectivePeriod?? = nil,
		id: String?? = nil,
		identifier: [Identifier]?? = nil,
		informationSource: InformationSource?? = nil,
		medication: Medication?? = nil,
		medicationTreatment: MedicationTreatment?? = nil,
		note: [Note]?? = nil,
		prescriber: Prescriber?? = nil,
		reasonCode: [[ReasonCode]]?? = nil,
		reasonForChangeOrDiscontinuationOfUse: [ReasonForChangeOrDiscontinuationOfUse]?? = nil,
		repeatPeriodCyclicalSchedule: RepeatPeriodCyclicalSchedule?? = nil,
		resourceType: String?? = nil,
		status: String?? = nil,
		subject: Subject?? = nil,
		taken: String?? = nil
	) -> ZibMedicationUse {
		return ZibMedicationUse(
			profile: profile ?? self.profile,
			asAgreedIndicator: asAgreedIndicator ?? self.asAgreedIndicator,
			author: author ?? self.author,
			category: category ?? self.category,
			dateAsserted: dateAsserted ?? self.dateAsserted,
			dosage: dosage ?? self.dosage,
			effectiveDuration: effectiveDuration ?? self.effectiveDuration,
			effectivePeriod: effectivePeriod ?? self.effectivePeriod,
			id: id ?? self.id,
			identifier: identifier ?? self.identifier,
			informationSource: informationSource ?? self.informationSource,
			medication: medication ?? self.medication,
			medicationTreatment: medicationTreatment ?? self.medicationTreatment,
			note: note ?? self.note,
			prescriber: prescriber ?? self.prescriber,
			reasonCode: reasonCode ?? self.reasonCode,
			reasonForChangeOrDiscontinuationOfUse: reasonForChangeOrDiscontinuationOfUse ?? self.reasonForChangeOrDiscontinuationOfUse,
			repeatPeriodCyclicalSchedule: repeatPeriodCyclicalSchedule ?? self.repeatPeriodCyclicalSchedule,
			resourceType: resourceType ?? self.resourceType,
			status: status ?? self.status,
			subject: subject ?? self.subject,
			taken: taken ?? self.taken
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

// MARK: - PurpleAuthor
public struct PurpleAuthor: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: PurpleAuthor convenience initializers and mutators

public extension PurpleAuthor {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleAuthor.self, from: data)
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
	) -> PurpleAuthor {
		return PurpleAuthor(
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Category
public struct Category: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: Category convenience initializers and mutators

public extension Category {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Category.self, from: data)
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
	) -> Category {
		return Category(
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

// MARK: - Dosage
public struct Dosage: Codable, Hashable, Sendable {
	public let additionalInstruction: [[AdditionalInstruction]]?
	public let asNeeded: [AsNeeded]?
	public let doseQuantity: DoseQuantity?
	public let doseRange: DoseRange?
	public let maxDosePerPeriod: MaxDosePerPeriod?
	public let rateQuantity: RateQuantity?
	public let rateRange: RateRange?
	public let rateRatio: RateRatio?
	public let timing: Timing

	public init(additionalInstruction: [[AdditionalInstruction]]?, asNeeded: [AsNeeded]?, doseQuantity: DoseQuantity?, doseRange: DoseRange?, maxDosePerPeriod: MaxDosePerPeriod?, rateQuantity: RateQuantity?, rateRange: RateRange?, rateRatio: RateRatio?, timing: Timing) {
		self.additionalInstruction = additionalInstruction
		self.asNeeded = asNeeded
		self.doseQuantity = doseQuantity
		self.doseRange = doseRange
		self.maxDosePerPeriod = maxDosePerPeriod
		self.rateQuantity = rateQuantity
		self.rateRange = rateRange
		self.rateRatio = rateRatio
		self.timing = timing
	}
}

// MARK: Dosage convenience initializers and mutators

public extension Dosage {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Dosage.self, from: data)
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
		additionalInstruction: [[AdditionalInstruction]]?? = nil,
		asNeeded: [AsNeeded]?? = nil,
		doseQuantity: DoseQuantity?? = nil,
		doseRange: DoseRange?? = nil,
		maxDosePerPeriod: MaxDosePerPeriod?? = nil,
		rateQuantity: RateQuantity?? = nil,
		rateRange: RateRange?? = nil,
		rateRatio: RateRatio?? = nil,
		timing: Timing? = nil
	) -> Dosage {
		return Dosage(
			additionalInstruction: additionalInstruction ?? self.additionalInstruction,
			asNeeded: asNeeded ?? self.asNeeded,
			doseQuantity: doseQuantity ?? self.doseQuantity,
			doseRange: doseRange ?? self.doseRange,
			maxDosePerPeriod: maxDosePerPeriod ?? self.maxDosePerPeriod,
			rateQuantity: rateQuantity ?? self.rateQuantity,
			rateRange: rateRange ?? self.rateRange,
			rateRatio: rateRatio ?? self.rateRatio,
			timing: timing ?? self.timing
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

// MARK: - AdditionalInstruction
public struct AdditionalInstruction: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: AdditionalInstruction convenience initializers and mutators

public extension AdditionalInstruction {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(AdditionalInstruction.self, from: data)
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
	) -> AdditionalInstruction {
		return AdditionalInstruction(
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

// MARK: - AsNeeded
public struct AsNeeded: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: AsNeeded convenience initializers and mutators

public extension AsNeeded {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(AsNeeded.self, from: data)
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
	) -> AsNeeded {
		return AsNeeded(
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

// MARK: - DoseQuantity
public struct DoseQuantity: Codable, Hashable, Sendable {
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

// MARK: DoseQuantity convenience initializers and mutators

public extension DoseQuantity {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(DoseQuantity.self, from: data)
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
	) -> DoseQuantity {
		return DoseQuantity(
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

public enum Comparator: String, Codable, Hashable, Sendable {
	case comparator = "<="
	case empty = "<"
	case fluffy = ">="
	case purple = ">"
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - DoseRange
public struct DoseRange: Codable, Hashable, Sendable {
	public let high: PurpleHigh?
	public let low: PurpleLow?

	public init(high: PurpleHigh?, low: PurpleLow?) {
		self.high = high
		self.low = low
	}
}

// MARK: DoseRange convenience initializers and mutators

public extension DoseRange {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(DoseRange.self, from: data)
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
		high: PurpleHigh?? = nil,
		low: PurpleLow?? = nil
	) -> DoseRange {
		return DoseRange(
			high: high ?? self.high,
			low: low ?? self.low
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

// MARK: - PurpleHigh
public struct PurpleHigh: Codable, Hashable, Sendable {
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

// MARK: PurpleHigh convenience initializers and mutators

public extension PurpleHigh {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleHigh.self, from: data)
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
	) -> PurpleHigh {
		return PurpleHigh(
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

// MARK: - PurpleLow
public struct PurpleLow: Codable, Hashable, Sendable {
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

// MARK: PurpleLow convenience initializers and mutators

public extension PurpleLow {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleLow.self, from: data)
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
	) -> PurpleLow {
		return PurpleLow(
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

// MARK: - MaxDosePerPeriod
public struct MaxDosePerPeriod: Codable, Hashable, Sendable {
	public let denominator: PurpleDenominator?
	public let numerator: PurpleNumerator?

	public init(denominator: PurpleDenominator?, numerator: PurpleNumerator?) {
		self.denominator = denominator
		self.numerator = numerator
	}
}

// MARK: MaxDosePerPeriod convenience initializers and mutators

public extension MaxDosePerPeriod {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(MaxDosePerPeriod.self, from: data)
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
		denominator: PurpleDenominator?? = nil,
		numerator: PurpleNumerator?? = nil
	) -> MaxDosePerPeriod {
		return MaxDosePerPeriod(
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

// MARK: - PurpleDenominator
public struct PurpleDenominator: Codable, Hashable, Sendable {
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

// MARK: PurpleDenominator convenience initializers and mutators

public extension PurpleDenominator {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleDenominator.self, from: data)
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
	) -> PurpleDenominator {
		return PurpleDenominator(
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

// MARK: - PurpleNumerator
public struct PurpleNumerator: Codable, Hashable, Sendable {
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

// MARK: PurpleNumerator convenience initializers and mutators

public extension PurpleNumerator {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleNumerator.self, from: data)
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
	) -> PurpleNumerator {
		return PurpleNumerator(
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

// MARK: - RateQuantity
public struct RateQuantity: Codable, Hashable, Sendable {
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

// MARK: RateQuantity convenience initializers and mutators

public extension RateQuantity {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(RateQuantity.self, from: data)
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
	) -> RateQuantity {
		return RateQuantity(
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

// MARK: - RateRange
public struct RateRange: Codable, Hashable, Sendable {
	public let high: FluffyHigh?
	public let low: FluffyLow?

	public init(high: FluffyHigh?, low: FluffyLow?) {
		self.high = high
		self.low = low
	}
}

// MARK: RateRange convenience initializers and mutators

public extension RateRange {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(RateRange.self, from: data)
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
		high: FluffyHigh?? = nil,
		low: FluffyLow?? = nil
	) -> RateRange {
		return RateRange(
			high: high ?? self.high,
			low: low ?? self.low
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

// MARK: - FluffyHigh
public struct FluffyHigh: Codable, Hashable, Sendable {
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

// MARK: FluffyHigh convenience initializers and mutators

public extension FluffyHigh {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyHigh.self, from: data)
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
	) -> FluffyHigh {
		return FluffyHigh(
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

// MARK: - FluffyLow
public struct FluffyLow: Codable, Hashable, Sendable {
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

// MARK: FluffyLow convenience initializers and mutators

public extension FluffyLow {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyLow.self, from: data)
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
	) -> FluffyLow {
		return FluffyLow(
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

// MARK: - RateRatio
public struct RateRatio: Codable, Hashable, Sendable {
	public let denominator: FluffyDenominator?
	public let numerator: FluffyNumerator?

	public init(denominator: FluffyDenominator?, numerator: FluffyNumerator?) {
		self.denominator = denominator
		self.numerator = numerator
	}
}

// MARK: RateRatio convenience initializers and mutators

public extension RateRatio {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(RateRatio.self, from: data)
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
		denominator: FluffyDenominator?? = nil,
		numerator: FluffyNumerator?? = nil
	) -> RateRatio {
		return RateRatio(
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

// MARK: - FluffyDenominator
public struct FluffyDenominator: Codable, Hashable, Sendable {
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

// MARK: FluffyDenominator convenience initializers and mutators

public extension FluffyDenominator {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyDenominator.self, from: data)
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
	) -> FluffyDenominator {
		return FluffyDenominator(
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

// MARK: - FluffyNumerator
public struct FluffyNumerator: Codable, Hashable, Sendable {
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

// MARK: FluffyNumerator convenience initializers and mutators

public extension FluffyNumerator {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyNumerator.self, from: data)
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
	) -> FluffyNumerator {
		return FluffyNumerator(
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

// MARK: - Timing
public struct Timing: Codable, Hashable, Sendable {
	public let dayOfWeek: [String]?
	public let duration: Double?
	public let durationUnit: String?
	public let frequency, frequencyMax, period: Double?
	public let periodUnit: String?
	public let timeOfDay: [[String]]?
	public let when: [String]?

	public init(dayOfWeek: [String]?, duration: Double?, durationUnit: String?, frequency: Double?, frequencyMax: Double?, period: Double?, periodUnit: String?, timeOfDay: [[String]]?, when: [String]?) {
		self.dayOfWeek = dayOfWeek
		self.duration = duration
		self.durationUnit = durationUnit
		self.frequency = frequency
		self.frequencyMax = frequencyMax
		self.period = period
		self.periodUnit = periodUnit
		self.timeOfDay = timeOfDay
		self.when = when
	}
}

// MARK: Timing convenience initializers and mutators

public extension Timing {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Timing.self, from: data)
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
		dayOfWeek: [String]?? = nil,
		duration: Double?? = nil,
		durationUnit: String?? = nil,
		frequency: Double?? = nil,
		frequencyMax: Double?? = nil,
		period: Double?? = nil,
		periodUnit: String?? = nil,
		timeOfDay: [[String]]?? = nil,
		when: [String]?? = nil
	) -> Timing {
		return Timing(
			dayOfWeek: dayOfWeek ?? self.dayOfWeek,
			duration: duration ?? self.duration,
			durationUnit: durationUnit ?? self.durationUnit,
			frequency: frequency ?? self.frequency,
			frequencyMax: frequencyMax ?? self.frequencyMax,
			period: period ?? self.period,
			periodUnit: periodUnit ?? self.periodUnit,
			timeOfDay: timeOfDay ?? self.timeOfDay,
			when: when ?? self.when
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

// MARK: - EffectiveDuration
public struct EffectiveDuration: Codable, Hashable, Sendable {
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

// MARK: EffectiveDuration convenience initializers and mutators

public extension EffectiveDuration {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(EffectiveDuration.self, from: data)
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
	) -> EffectiveDuration {
		return EffectiveDuration(
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

// MARK: - EffectivePeriod
public struct EffectivePeriod: Codable, Hashable, Sendable {
	public let end, start: String?

	public init(end: String?, start: String?) {
		self.end = end
		self.start = start
	}
}

// MARK: EffectivePeriod convenience initializers and mutators

public extension EffectivePeriod {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(EffectivePeriod.self, from: data)
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
		end: String? = nil,
		start: String? = nil
	) -> EffectivePeriod {
		return EffectivePeriod(
			end: end ?? self.end,
			start: start ?? self.start
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

// MARK: - Identifier
public struct Identifier: Codable, Hashable, Sendable {
	public let system: String?
	public let type: [PurpleType]?
	public let use: Use?
	public let value: String?

	public init(system: String?, type: [PurpleType]?, use: Use?, value: String?) {
		self.system = system
		self.type = type
		self.use = use
		self.value = value
	}
}

// MARK: Identifier convenience initializers and mutators

public extension Identifier {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Identifier.self, from: data)
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
		system: String?? = nil,
		type: [PurpleType]?? = nil,
		use: Use?? = nil,
		value: String?? = nil
	) -> Identifier {
		return Identifier(
			system: system ?? self.system,
			type: type ?? self.type,
			use: use ?? self.use,
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

// MARK: - PurpleType
public struct PurpleType: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: PurpleType convenience initializers and mutators

public extension PurpleType {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(PurpleType.self, from: data)
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
	) -> PurpleType {
		return PurpleType(
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

public enum Use: String, Codable, Hashable, Sendable {
	case official = "official"
	case secondary = "secondary"
	case temp = "temp"
	case usual = "usual"
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - InformationSource
public struct InformationSource: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: InformationSource convenience initializers and mutators

public extension InformationSource {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(InformationSource.self, from: data)
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
	) -> InformationSource {
		return InformationSource(
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Medication
public struct Medication: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: Medication convenience initializers and mutators

public extension Medication {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Medication.self, from: data)
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
	) -> Medication {
		return Medication(
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - MedicationTreatment
public struct MedicationTreatment: Codable, Hashable, Sendable {
	public let system: String?
	public let type: [FluffyType]?
	public let use: Use?
	public let value: String?

	public init(system: String?, type: [FluffyType]?, use: Use?, value: String?) {
		self.system = system
		self.type = type
		self.use = use
		self.value = value
	}
}

// MARK: MedicationTreatment convenience initializers and mutators

public extension MedicationTreatment {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(MedicationTreatment.self, from: data)
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
		system: String?? = nil,
		type: [FluffyType]?? = nil,
		use: Use?? = nil,
		value: String?? = nil
	) -> MedicationTreatment {
		return MedicationTreatment(
			system: system ?? self.system,
			type: type ?? self.type,
			use: use ?? self.use,
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

// MARK: - FluffyType
public struct FluffyType: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: FluffyType convenience initializers and mutators

public extension FluffyType {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyType.self, from: data)
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
	) -> FluffyType {
		return FluffyType(
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

// MARK: - Note
public struct Note: Codable, Hashable, Sendable {
	public let author: FluffyAuthor?
	public let text: String
	public let time: [String]?

	public init(author: FluffyAuthor?, text: String, time: [String]?) {
		self.author = author
		self.text = text
		self.time = time
	}
}

// MARK: Note convenience initializers and mutators

public extension Note {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Note.self, from: data)
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
		author: FluffyAuthor?? = nil,
		text: String? = nil,
		time: [String]?? = nil
	) -> Note {
		return Note(
			author: author ?? self.author,
			text: text ?? self.text,
			time: time ?? self.time
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

// MARK: - FluffyAuthor
public struct FluffyAuthor: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: FluffyAuthor convenience initializers and mutators

public extension FluffyAuthor {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(FluffyAuthor.self, from: data)
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
	) -> FluffyAuthor {
		return FluffyAuthor(
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Prescriber
public struct Prescriber: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: Prescriber convenience initializers and mutators

public extension Prescriber {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Prescriber.self, from: data)
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
	) -> Prescriber {
		return Prescriber(
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

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReasonCode
public struct ReasonCode: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: ReasonCode convenience initializers and mutators

public extension ReasonCode {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ReasonCode.self, from: data)
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
	) -> ReasonCode {
		return ReasonCode(
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

// MARK: - ReasonForChangeOrDiscontinuationOfUse
public struct ReasonForChangeOrDiscontinuationOfUse: Codable, Hashable, Sendable {
	public let code, display, system: String?

	public init(code: String?, display: String?, system: String?) {
		self.code = code
		self.display = display
		self.system = system
	}
}

// MARK: ReasonForChangeOrDiscontinuationOfUse convenience initializers and mutators

public extension ReasonForChangeOrDiscontinuationOfUse {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(ReasonForChangeOrDiscontinuationOfUse.self, from: data)
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
	) -> ReasonForChangeOrDiscontinuationOfUse {
		return ReasonForChangeOrDiscontinuationOfUse(
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

// MARK: - RepeatPeriodCyclicalSchedule
public struct RepeatPeriodCyclicalSchedule: Codable, Hashable, Sendable {
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

// MARK: RepeatPeriodCyclicalSchedule convenience initializers and mutators

public extension RepeatPeriodCyclicalSchedule {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(RepeatPeriodCyclicalSchedule.self, from: data)
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
	) -> RepeatPeriodCyclicalSchedule {
		return RepeatPeriodCyclicalSchedule(
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

// MARK: - Subject
public struct Subject: Codable, Hashable, Sendable {
	public let display, reference: String?

	public init(display: String?, reference: String?) {
		self.display = display
		self.reference = reference
	}
}

// MARK: Subject convenience initializers and mutators

public extension Subject {
	init(data: Data) throws {
		self = try newJSONDecoder().decode(Subject.self, from: data)
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
	) -> Subject {
		return Subject(
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

//public typealias DateTimeString = [String]
//public typealias NictizNlProfile = [String]
//
//public extension Array where Element == DateTimeString.Element {
//	init(data: Data) throws {
//		self = try newJSONDecoder().decode(DateTimeString.self, from: data)
//	}
//
//	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//		guard let data = json.data(using: encoding) else {
//			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//		}
//		try self.init(data: data)
//	}
//
//	init(fromURL url: URL) throws {
//		try self.init(data: try Data(contentsOf: url))
//	}
//
//	func jsonData() throws -> Data {
//		return try newJSONEncoder().encode(self)
//	}
//
//	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//		return String(data: try self.jsonData(), encoding: encoding)
//	}
//}
//
//public extension Array where Element == NictizNlProfile.Element {
//	init(data: Data) throws {
//		self = try newJSONDecoder().decode(NictizNlProfile.self, from: data)
//	}
//
//	init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//		guard let data = json.data(using: encoding) else {
//			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//		}
//		try self.init(data: data)
//	}
//
//	init(fromURL url: URL) throws {
//		try self.init(data: try Data(contentsOf: url))
//	}
//
//	func jsonData() throws -> Data {
//		return try newJSONEncoder().encode(self)
//	}
//
//	func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//		return String(data: try self.jsonData(), encoding: encoding)
//	}
//}

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
