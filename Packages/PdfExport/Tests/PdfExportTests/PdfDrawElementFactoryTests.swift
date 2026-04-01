/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import PdfExport

@MainActor
@Suite
struct PdfDrawElementFactoryTests {
	
	private var sut: PdfDrawElementFactory
	
	init() {
		sut = PdfDrawElementFactory(theme: ExportTheme())
	}
	
	@Test("createPdfHeadingDrawElement returns element with correct text, rect, and no border")
	func pdfHeading() {
		
		// Given
		let pdfData = PdfData(
			heading: "test_pdfHeading",
			subHeading: "",
			tables: [],
			footer: ""
		)
		
		// When
		let drawElement = sut.createPdfHeadingDrawElement(
			pdfData,
			yPosition: 20
		)
		
		// Then
		#expect(drawElement.text?.string == "test_pdfHeading")
		#expect(drawElement.borderColor == nil)
		#expect(drawElement.rect == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 27.6)
		)
		#expect(drawElement.height == 27.6)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createPdfSubHeadingDrawElement returns right-aligned element with zero height")
	func pdfSubHeading() {
		
		// Given
		let pdfData = PdfData(
			heading: "",
			subHeading: "test_pdfSubHeading",
			tables: [],
			footer: ""
		)
		
		// When
		let drawElement = sut.createPdfSubHeadingDrawElement(
			pdfData,
			yPosition: 20
		)
		
		// Then
		#expect(drawElement.text?.string == "test_pdfSubHeading")
		#expect(drawElement.borderColor == nil)
		#expect(drawElement.rect == CGRect(
			x: 476.655,
			y: 20,
			width: 90.625,
			height: 11.5)
		)
		#expect(drawElement.height == 0)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createGroupedHeadingDrawElement returns element with correct text and dimensions")
	func groupedHeading() {
		
		// Given
		let groupedTables = PdfGroupedTables(
			heading: "test_groupedHeading",
			tables: []
		)
		
		// When
		let drawElement = sut.createGroupedHeadingDrawElement(
			groupedTables,
			yPosition: 20
		)
		
		// Then
		#expect(drawElement.text?.string == "test_groupedHeading")
		#expect(drawElement.borderColor == nil)
		#expect(drawElement.rect == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 34.4)
		)
		#expect(drawElement.height == 34.4)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createTableHeadingDrawElement returns element with border and correct dimensions")
	func tableHeading() {
		
		// Given
		let table = PdfTable(
			heading: "test_tableHeading",
			subTables: []
		)
		
		// When
		let drawElement = sut.createTableHeadingDrawElement(
			table,
			yPosition: 20
		)
		
		// Then
		#expect(drawElement.text?.string == "test_tableHeading")
		#expect(drawElement.borderColor == ExportTheme().border)
		#expect(drawElement.borderSides == .all)
		#expect(drawElement.rect == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 16.1)
		)
		#expect(drawElement.height == 34.1)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createSubTableHeadingDrawElement returns element with border and correct dimensions")
	func subTableHeading() {
		
		// Given
		
		// When
		let drawElement = sut.createSubTableHeadingDrawElement(
			heading: "test_subTableHeading",
			yPosition: 20
		)
		
		// Then
		#expect(drawElement.text?.string == "test_subTableHeading")
		#expect(drawElement.borderColor == ExportTheme().border)
		#expect(drawElement.borderSides == .all)
		#expect(drawElement.rect == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 13.8)
		)
		#expect(drawElement.height == 21.8)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createSubTableRowDrawElement returns two elements with correct key/value styling")
	func subTablePair() throws {
		
		// Given
		let pair = PdfSubTablePair(
			key: "key",
			value: "value"
		)
		
		// When
		let drawElements = sut.createSubTableRowDrawElement(
			pair,
			yPosition: 20
		)
		
		// Then
		try #require(drawElements.count == 2)
		
		let keyElement = try #require(drawElements.first)
		#expect(keyElement.text?.string == "key")
		#expect(keyElement.borderColor == ExportTheme().border)
		#expect(keyElement.borderSides == .all)
		#expect(keyElement.rect == CGRect(
			x: 28,
			y: 20,
			width: 269.64,
			height: 11.5)
		)
		#expect(keyElement.height == 19.5)
		#expect(keyElement.isPageBreak == false)
		
		let valueElement = try #require(drawElements.last)
		#expect(valueElement.text?.string == "value")
		#expect(valueElement.borderColor == ExportTheme().border)
		#expect(valueElement.borderSides == .all)
		#expect(valueElement.rect == CGRect(
			x: 297.64,
			y: 20,
			width: 269.64,
			height: 11.5)
		)
		#expect(valueElement.height == 19.5)
		#expect(valueElement.isPageBreak == false)
	}
	
	@Test("createFooterElement returns element positioned at bottom of page")
	func footer() {
		
		// Given
		let pdfData = PdfData(
			heading: "",
			subHeading: "",
			tables: [],
			footer: "test_footer"
		)
		
		// When
		let drawElement = sut.createFooterElement(pdfData)
		
		// Then
		#expect(drawElement.text?.string == "test_footer")
		#expect(drawElement.borderColor == nil)
		#expect(drawElement.rect == CGRect(
			x: 28,
			y: 774.39,
			width: 539.28,
			height: 11.5)
		)
		#expect(drawElement.height == 11.5)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createPaginationElement returns right-aligned element with zero height")
	func paginationElement() {
		
		// Given
		
		// When
		let drawElement = sut.createPaginationElement("pagina 2 van 5")
		
		// Then
		#expect(drawElement.text?.string == "pagina 2 van 5")
		#expect(drawElement.borderColor == nil)
		#expect(drawElement.rect == CGRect(
			x: 501.6696484375,
			y: 774.39,
			width: 65.6103515625,
			height: 11.5)
		)
		#expect(drawElement.height == 0)
		#expect(drawElement.isPageBreak == false)
	}
	
	@Test("createEmptySubCategoryDrawElement returns full-width element with border")
	func emptySubCategory() {
		
		// Given
		
		// When
		let drawElement = sut.createEmptySubCategoryDrawElement(
			"geen gegevens beschikbaar",
			yPosition: 20
		)
		
		// Then
		#expect(drawElement.text?.string == "geen gegevens beschikbaar")
		#expect(drawElement.borderColor == ExportTheme().border)
		#expect(drawElement.borderSides == .all)
		#expect(drawElement.rect == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 11.5)
		)
		#expect(drawElement.height == 11.5)
		#expect(drawElement.isPageBreak == false)
	}
}
