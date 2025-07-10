/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import PdfExport

final class PdfDrawElementFactoryTests: XCTestCase {
	
	var sut: PdfDrawElementFactory!
	
	override func setUp() {
		super.setUp()
		
		sut = PdfDrawElementFactory(theme: ExportTheme())
	}
	
	@MainActor func test_pdfHeading() {
		
		// Given
		let pdfData = PdfData(heading: "test_pdfHeading", subHeading: "", tables: [], footer: "")
		
		// When
		let drawElement = sut.createPdfHeadingDrawElement(pdfData, yPosition: 20)
		
		// Then
		expect(drawElement.text?.string) == "test_pdfHeading"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == nil
		expect(drawElement.rect) == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 27.6
		)
		expect(drawElement.height) == 27.6
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_pdfSubHeading() {
		
		// Given
		let pdfData = PdfData(heading: "", subHeading: "test_pdfSubHeading", tables: [], footer: "")
		
		// When
		let drawElement = sut.createPdfSubHeadingDrawElement(pdfData, yPosition: 20)
		
		// Then
		expect(drawElement.text?.string) == "test_pdfSubHeading"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == nil
		expect(drawElement.rect) == CGRect(
			x: 476.655,
			y: 20,
			width: 90.625,
			height: 11.5
		)
		expect(drawElement.height) == 0
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_groupedHeading() {
		
		// Given
		let groupedTables = PdfGroupedTables(heading: "test_groupedHeading", tables: [])
		
		// When
		let drawElement = sut.createGroupedHeadingDrawElement(groupedTables, yPosition: 20)
		
		// Then
		expect(drawElement.text?.string) == "test_groupedHeading"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == nil
		expect(drawElement.rect) == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 30.4
		)
		expect(drawElement.height) == 30.4
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_tableHeading() {
		
		// Given
		let table = PdfTable(heading: "test_tableHeading", subTables: [])
		
		// When
		let drawElement = sut.createTableHeadingDrawElement(table, yPosition: 20)
		
		// Then
		expect(drawElement.text?.string) == "test_tableHeading"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == ExportTheme().border
		expect(drawElement.rect) == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 13.8
		)
		expect(drawElement.height) == 24.8
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_subTableHeading() {
		
		// Given
		
		// When
		let drawElement = sut.createSubTableHeadingDrawElement(heading: "test_subTableHeading", yPosition: 20)
		
		// Then
		expect(drawElement.text?.string) == "test_subTableHeading"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == ExportTheme().border
		expect(drawElement.rect) == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 11.5
		)
		expect(drawElement.height) == 22.5
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_subTablePair() {
		
		// Given
		let pair = PdfSubTablePair(key: "key", value: "value")
		
		// When
		let drawElements = sut.createSubTableRowDrawElement(pair, yPosition: 20)

		// Then
		expect(drawElements).to(haveCount(2))
		
		expect(drawElements.first?.text?.string) == "key"
		expect(drawElements.first?.backgroundColor) == ExportTheme().secondaryBackground
		expect(drawElements.first?.borderColor) == ExportTheme().border
		expect(drawElements.first?.rect) == CGRect(
			x: 28,
			y: 20,
			width: 269.64,
			height: 11.5
		)
		expect(drawElements.first?.height) == 22.5
		expect(drawElements.first?.isPageBreak) == false
		
		expect(drawElements.last?.text?.string) == "value"
		expect(drawElements.last?.backgroundColor) == nil
		expect(drawElements.last?.borderColor) == ExportTheme().border
		expect(drawElements.last?.rect) == CGRect(
			x: 296.64,
			y: 20,
			width: 270.64,
			height: 11.5
		)
		expect(drawElements.last?.height) == 22.5
		expect(drawElements.last?.isPageBreak) == false
	}
	
	@MainActor func test_footer() {
		
		// Given
		let pdfData = PdfData(heading: "", subHeading: "", tables: [], footer: "test_footer")
		
		// When
		let drawElement = sut.createFooterElement(pdfData)
		
		// Then
		expect(drawElement.text?.string) == "test_footer"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == nil
		expect(drawElement.rect) == CGRect(
			x: 28,
			y: 774.39,
			width: 539.28,
			height: 11.5
		)
		expect(drawElement.height) == 11.5
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_paginationElement() {
		
		// Given
		
		// When
		let drawElement = sut.createPaginationElement("pagina 2 van 5")
		
		// Then
		expect(drawElement.text?.string) == "pagina 2 van 5"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == nil
		expect(drawElement.rect) == CGRect(
			x: 501.6696484375,
			y: 774.39,
			width: 65.6103515625,
			height: 11.5
		)
		expect(drawElement.height) == 0
		expect(drawElement.isPageBreak) == false
	}
	
	@MainActor func test_emptySubCategory() {
		
		// Given
		
		// When
		let drawElement = sut.createEmptySubCategoryDrawElement("geen gegevens beschikbaar", yPosition: 20)
		
		// Then
		expect(drawElement.text?.string) == "geen gegevens beschikbaar"
		expect(drawElement.backgroundColor) == nil
		expect(drawElement.borderColor) == ExportTheme().border
		expect(drawElement.rect) == CGRect(
			x: 28,
			y: 20,
			width: 539.28,
			height: 11.5
		)
		expect(drawElement.height) == 11.5
		expect(drawElement.isPageBreak) == false
	}
}
