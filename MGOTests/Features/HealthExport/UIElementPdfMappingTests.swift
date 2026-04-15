/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import PdfExport
@testable import MGO

@Suite
struct UIElementPdfMappingTests {
	
	// MARK: - SingleValue
	
	@Test("SingleValue getPdfMapping returns standard pair with label and display")
	func singleValue_withDisplay() throws {
		
		// Given
		let element = SingleValue(
			id: "1",
			label: "Naam",
			type: .singleValue,
			value: DisplayValue(
				code: nil,
				display: "Jan Jansen",
				system: nil
			)
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .standard)
		#expect(pair.key == element.label)
		#expect(pair.value == element.value?.display)
		#expect(pair.style == .standard)
	}
	
	@Test("SingleValue getPdfMapping returns nil when value is nil")
	func singleValue_withNilValue() {
		
		// Given
		let element = SingleValue(
			id: "1",
			label: "Naam",
			type: .singleValue,
			value: nil
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	@Test("SingleValue getPdfMapping returns nil when label is empty")
	func singleValue_withEmptyLabel() {
		
		// Given
		let element = SingleValue(
			id: "1",
			label: "",
			type: .singleValue,
			value: DisplayValue(
				code: nil,
				display: "Jan Jansen",
				system: nil
			)
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	@Test("SingleValue getPdfMapping returns nil when display is nil")
	func singleValue_withNilDisplay() {
		
		// Given
		let element = SingleValue(
			id: "1",
			label: "Naam",
			type: .singleValue,
			value: DisplayValue(code: nil, display: nil, system: nil)
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	// MARK: - MultipleValues
	
	@Test("MultipleValues getPdfMapping returns values joined with newline")
	func multipleValues_withValues() throws {
		
		// Given
		let element = MultipleValues(
			id: "1",
			label: "Diagnoses",
			type: .multipleValues,
			value: [
				DisplayValue(code: nil, display: "Hypertensie", system: nil),
				DisplayValue(code: nil, display: "Diabetes", system: nil)
			]
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .standard)
		#expect(pair.key == element.label)
		#expect(pair.value == "Hypertensie\nDiabetes")
		#expect(pair.style == .standard)
	}
	
	@Test("MultipleValues getPdfMapping returns nil when value is nil")
	func multipleValues_withNilValue() {
		
		// Given
		let element = MultipleValues(
			id: "1",
			label: "Diagnoses",
			type: .multipleValues,
			value: nil
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	@Test("MultipleValues getPdfMapping returns nil when label is empty")
	func multipleValues_withEmptyLabel() {
		
		// Given
		let element = MultipleValues(
			id: "1",
			label: "",
			type: .multipleValues,
			value: [
				DisplayValue(code: nil, display: "Hypertensie", system: nil),
				DisplayValue(code: nil, display: "Diabetes", system: nil)
			]
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	@Test("MultipleValues getPdfMapping returns nil when all displays are nil")
	func multipleValues_withAllNilDisplays() {
		
		// Given
		let element = MultipleValues(
			id: "1",
			label: "Diagnoses",
			type: .multipleValues,
			value: [
				DisplayValue(code: nil, display: nil, system: nil)
			]
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	// MARK: - MultipleGroupedValues
	
	@Test("MultipleGroupedValues getPdfMapping flattens groups and joins with newline")
	func multipleGroupedValues_withGroups() throws {
		
		// Given
		let element = MultipleGroupedValues(
			id: "1",
			label: "Medicijnen",
			type: .multipleGroupedValues,
			value: [
				[DisplayValue(code: nil, display: "Aspirine", system: nil)],
				[
					DisplayValue(code: nil, display: "Ibuprofen", system: nil),
					DisplayValue(code: nil, display: "Paracetamol", system: nil)
				]
			]
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .standard)
		#expect(pair.key == element.label)
		#expect(pair.value == "Aspirine\nIbuprofen\nParacetamol")
		#expect(pair.style == .standard)
	}
	
	@Test("MultipleGroupedValues getPdfMapping returns nil when label is empty")
	func multipleGroupedValues_withEmptyLabel() {
		
		// Given
		let element = MultipleGroupedValues(
			id: "1",
			label: "",
			type: .multipleGroupedValues,
			value: [
				[DisplayValue(code: nil, display: "Aspirine", system: nil)],
				[
					DisplayValue(code: nil, display: "Ibuprofen", system: nil),
					DisplayValue(code: nil, display: "Paracetamol", system: nil)
				]
			]
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	@Test("MultipleGroupedValues getPdfMapping returns nil when value is nil")
	func multipleGroupedValues_withNilValue() {
		
		// Given
		let element = MultipleGroupedValues(
			id: "1",
			label: "Medicijnen",
			type: .multipleGroupedValues,
			value: nil
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	// MARK: - ReferenceValue
	
	@Test("ReferenceValue getPdfMapping returns standard pair with label and display")
	func referenceValue_withDisplay() throws {
		
		// Given
		let element = ReferenceValue(
			display: "Actief",
			id: "1",
			label: "Status",
			reference: nil,
			type: .referenceValue
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .standard)
		#expect(pair.key == element.label)
		#expect(pair.value == element.display)
		#expect(pair.style == .standard)
	}
	
	@Test("ReferenceValue getPdfMapping returns nil when display is nil")
	func referenceValue_withNilDisplay() {
		
		// Given
		let element = ReferenceValue(
			display: nil,
			id: "1",
			label: "Status",
			reference: nil,
			type: .referenceValue
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	@Test("ReferenceValue getPdfMapping returns nil when label is empty")
	func referenceValue_withEmptyLabel() {
		
		// Given
		let element = ReferenceValue(
			display: "Actief",
			id: "1",
			label: "",
			reference: nil,
			type: .referenceValue
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	// MARK: - ReferenceLink
	
	@Test("ReferenceLink getPdfMapping returns standard pair with label and reference")
	func referenceLink_mapping() throws {
		
		// Given
		let element = ReferenceLink(
			id: "1",
			label: "Meer informatie",
			reference: "https://example.com",
			type: .referenceLink
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .standard)
		#expect(pair.key == element.label)
		#expect(pair.value == element.reference)
		#expect(pair.style == .standard)
	}

	// MARK: - DownloadLink
	
	@Test("DownloadLink getPdfMapping returns download style with label as value")
	func downloadLink_mapping() throws {
		
		// Given
		let element = DownloadLink(
			id: "1",
			label: "Bijlage rapport.pdf",
			type: .downloadLink,
			url: nil
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .download)
		#expect(pair.value == element.label)
		#expect(pair.key == "")
	}
	
	@Test("DownloadLink getPdfMapping returns nil when label is empty")
	func downloadLink_withEmptyLabel() throws {
		
		// Given
		let element = DownloadLink(
			id: "1",
			label: "",
			type: .downloadLink,
			url: nil
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
	
	// MARK: - DownloadBinary
	
	@Test("DownloadBinary getPdfMapping returns download style with label as value")
	func downloadBinary_mapping() throws {
		
		// Given
		let element = DownloadBinary(
			id: "1",
			label: "Scan resultaat.pdf",
			reference: nil,
			type: .downloadBinary
		)
		
		// When
		let pair = try #require(element.getPdfMapping())
		
		// Then
		#expect(pair.style == .download)
		#expect(pair.value == element.label)
		#expect(pair.key == "")
	}
	
	@Test("DownloadBinary getPdfMapping returns nil when label is empty")
	func downloadBinary_withEmptyLabel() throws {
		
		// Given
		let element = DownloadBinary(
			id: "1",
			label: "",
			reference: nil,
			type: .downloadBinary
		)
		
		// When / Then
		#expect(element.getPdfMapping() == nil)
	}
}
